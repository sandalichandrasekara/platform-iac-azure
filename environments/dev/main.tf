data "azurerm_client_config" "current" {}

locals {
  name_prefix = "${var.project}-${var.environment}"

  tags = merge(
    {
      project     = var.project
      environment = var.environment
      managedBy   = "terraform"
    },
    var.tags,
  )
}

resource "azurerm_resource_group" "this" {
  name     = "rg-${local.name_prefix}"
  location = var.location
  tags     = local.tags
}

module "networking" {
  source              = "../../modules/networking"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = local.tags
}

module "observability" {
  source                = "../../modules/observability"
  name_prefix           = local.name_prefix
  location              = var.location
  resource_group_name   = azurerm_resource_group.this.name
  alert_email_receivers = var.alert_email_receivers
  tags                  = local.tags
}

module "acr" {
  source                     = "../../modules/acr"
  name                       = var.acr_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.this.name
  vnet_id                    = module.networking.vnet_id
  private_endpoint_subnet_id = module.networking.private_endpoints_subnet_id
  tags                       = local.tags
}

module "key_vault" {
  source                     = "../../modules/key_vault"
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = azurerm_resource_group.this.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  vnet_id                    = module.networking.vnet_id
  private_endpoint_subnet_id = module.networking.private_endpoints_subnet_id
  tags                       = local.tags
}

module "app_gateway" {
  source              = "../../modules/app_gateway"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  subnet_id           = module.networking.appgw_subnet_id
  tags                = local.tags
}

module "aks" {
  source                     = "../../modules/aks"
  name_prefix                = local.name_prefix
  location                   = var.location
  resource_group_name        = azurerm_resource_group.this.name
  resource_group_id          = azurerm_resource_group.this.id
  aks_subnet_id              = module.networking.aks_subnet_id
  log_analytics_workspace_id = module.observability.workspace_id
  acr_id                     = module.acr.acr_id
  gateway_id                 = module.app_gateway.gateway_id
  aks_admin_group_object_ids = var.aks_admin_group_object_ids
  tags                       = local.tags
}

# Federate the workload identity to the freshly created cluster's OIDC issuer.
module "identity" {
  source              = "../../modules/identity"
  name_prefix         = local.name_prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.this.name
  oidc_issuer_url     = module.aks.oidc_issuer_url
  tags                = local.tags
}

module "database" {
  source                     = "../../modules/database"
  name_prefix                = local.name_prefix
  location                   = var.location
  resource_group_name        = azurerm_resource_group.this.name
  vnet_id                    = module.networking.vnet_id
  private_endpoint_subnet_id = module.networking.private_endpoints_subnet_id
  aad_admin_login            = var.sql_aad_admin_login
  aad_admin_object_id        = var.sql_aad_admin_object_id
  tags                       = local.tags
}

module "policy" {
  source            = "../../modules/policy"
  name_prefix       = local.name_prefix
  location          = var.location
  resource_group_id = azurerm_resource_group.this.id
  allowed_locations = [var.location]
}

# Allow application pods (via workload identity) to read Key Vault secrets.
resource "azurerm_role_assignment" "workload_kv_secrets" {
  scope                = module.key_vault.key_vault_id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = module.identity.principal_id
}

# Local accounts are disabled, so the CI deploy identity needs Azure RBAC
# cluster-admin to apply manifests via kubectl/kubelogin.
resource "azurerm_role_assignment" "ci_aks_admin" {
  count                = var.ci_principal_object_id == "" ? 0 : 1
  scope                = module.aks.cluster_id
  role_definition_name = "Azure Kubernetes Service RBAC Cluster Admin"
  principal_id         = var.ci_principal_object_id
}
