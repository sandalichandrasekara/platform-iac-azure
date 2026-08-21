# Workload identity used by application pods. No client secret is ever issued;
# the pod's projected service-account token is exchanged for an Azure token.
resource "azurerm_user_assigned_identity" "workload" {
  name                = "${var.name_prefix}-workload-id"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Federate the Kubernetes service account to the managed identity over OIDC.
resource "azurerm_federated_identity_credential" "workload" {
  name                = "${var.name_prefix}-workload-fic"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.workload.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
}
