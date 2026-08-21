output "identity_id" {
  description = "Resource ID of the workload managed identity."
  value       = azurerm_user_assigned_identity.workload.id
}

output "client_id" {
  description = "Client ID used by workload identity (set on the K8s service account annotation)."
  value       = azurerm_user_assigned_identity.workload.client_id
}

output "principal_id" {
  description = "Principal (object) ID for role assignments."
  value       = azurerm_user_assigned_identity.workload.principal_id
}

output "tenant_id" {
  description = "Tenant ID of the managed identity."
  value       = azurerm_user_assigned_identity.workload.tenant_id
}
