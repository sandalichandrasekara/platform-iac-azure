output "resource_group_name" {
  description = "Resource group holding the platform."
  value       = azurerm_resource_group.this.name
}

output "aks_cluster_name" {
  description = "AKS cluster name (for az aks get-credentials)."
  value       = module.aks.cluster_name
}

output "aks_cluster_id" {
  description = "Resource ID of the AKS cluster."
  value       = module.aks.cluster_id
}

output "oidc_issuer_url" {
  description = "AKS OIDC issuer URL (used by k8s-extensions for federated credentials)."
  value       = module.aks.oidc_issuer_url
}

output "subscription_id" {
  description = "Azure subscription ID (consumed by downstream layers' provider config)."
  value       = var.subscription_id
}

# Consumed by k8s-base / k8s-extensions to configure the kubernetes/helm providers
# against an AAD-only (local accounts disabled) cluster via kubelogin.
output "kube_config_host" {
  description = "AKS API server URL."
  value       = module.aks.kube_config_host
}

output "kube_config_ca_certificate" {
  description = "Base64 cluster CA certificate."
  value       = module.aks.kube_config_ca_certificate
  sensitive   = true
}

output "acr_login_server" {
  description = "ACR login server for image pushes/pulls."
  value       = module.acr.login_server
}

output "key_vault_id" {
  description = "Key Vault resource ID (consumed by downstream layers)."
  value       = module.key_vault.key_vault_id
}

output "key_vault_uri" {
  description = "Key Vault URI."
  value       = module.key_vault.key_vault_uri
}

output "app_gateway_public_ip" {
  description = "Public IP of the Application Gateway ingress."
  value       = module.app_gateway.public_ip_address
}

output "workload_identity_client_id" {
  description = "Client ID to annotate on the Kubernetes service account."
  value       = module.identity.client_id
}

output "workload_identity_id" {
  description = "Resource ID of the workload managed identity (parent for federated credentials)."
  value       = module.identity.identity_id
}

output "tenant_id" {
  description = "Azure AD tenant ID."
  value       = data.azurerm_client_config.current.tenant_id
}

output "sql_server_fqdn" {
  description = "Private FQDN of the SQL server."
  value       = module.database.server_fqdn
}
