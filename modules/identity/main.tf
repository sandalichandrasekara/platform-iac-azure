# Federated to a K8s service account over OIDC — no client secret is issued.
resource "azurerm_user_assigned_identity" "workload" {
  name                = "${var.name_prefix}-workload-id"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_federated_identity_credential" "workload" {
  name                = "${var.name_prefix}-workload-fic"
  resource_group_name = var.resource_group_name
  parent_id           = azurerm_user_assigned_identity.workload.id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = var.oidc_issuer_url
  subject             = "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
}
