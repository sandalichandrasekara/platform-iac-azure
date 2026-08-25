output "workload_identity_client_id" {
  description = "Client ID annotated on the workload service account."
  value       = module.identity.client_id
}

# Local accounts are disabled, so downstream layers configure the kubernetes/helm
# providers from these via kubelogin.
output "kube_config_host" {
  description = "AKS API server URL."
  value       = module.aks.kube_config_host
}

output "kube_config_ca_certificate" {
  description = "Base64 cluster CA certificate."
  value       = module.aks.kube_config_ca_certificate
  sensitive   = true
}

# --- Operator-facing ---

output "resource_group_name" {
  description = "Resource group holding the platform."
  value       = azurerm_resource_group.this.name
}

output "aks_cluster_name" {
  description = "AKS cluster name (for az aks get-credentials)."
  value       = module.aks.cluster_name
}

output "acr_login_server" {
  description = "ACR login server for image pushes/pulls."
  value       = module.acr.login_server
}

output "key_vault_uri" {
  description = "Key Vault URI."
  value       = module.key_vault.key_vault_uri
}

output "app_gateway_public_ip" {
  description = "Public IP of the Application Gateway ingress."
  value       = module.app_gateway.public_ip_address
}

output "sql_server_fqdn" {
  description = "Private FQDN of the SQL server."
  value       = module.database.server_fqdn
}
