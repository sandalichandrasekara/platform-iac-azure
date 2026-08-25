output "cluster_id" {
  description = "Resource ID of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.id
}

output "cluster_name" {
  description = "Name of the AKS cluster."
  value       = azurerm_kubernetes_cluster.this.name
}

output "oidc_issuer_url" {
  description = "OIDC issuer URL (consumed by the identity module for federation)."
  value       = azurerm_kubernetes_cluster.this.oidc_issuer_url
}

# Local accounts are disabled, so kube_admin_config is empty. Downstream layers
# configure the kubernetes/helm providers via AAD (kubelogin exec) using these.
output "kube_config_host" {
  description = "API server URL from the AAD-integrated kube_config."
  value       = azurerm_kubernetes_cluster.this.kube_config[0].host
}

output "kube_config_ca_certificate" {
  description = "Base64 cluster CA certificate from the AAD-integrated kube_config."
  value       = azurerm_kubernetes_cluster.this.kube_config[0].cluster_ca_certificate
  sensitive   = true
}
