output "workspace_id" {
  description = "Resource ID of the Log Analytics workspace."
  value       = azurerm_log_analytics_workspace.this.id
}

output "workspace_customer_id" {
  description = "Workspace (customer) GUID."
  value       = azurerm_log_analytics_workspace.this.workspace_id
}

output "action_group_id" {
  description = "Resource ID of the critical Action Group."
  value       = azurerm_monitor_action_group.critical.id
}
