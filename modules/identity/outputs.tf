output "client_id" {
  description = "Client ID used by workload identity (set on the K8s service account annotation)."
  value       = azurerm_user_assigned_identity.workload.client_id
}

output "principal_id" {
  description = "Principal (object) ID for role assignments."
  value       = azurerm_user_assigned_identity.workload.principal_id
}
