output "allowed_locations_assignment_id" {
  description = "ID of the allowed-locations policy assignment."
  value       = azurerm_resource_group_policy_assignment.allowed_locations.id
}

output "require_tag_assignment_id" {
  description = "ID of the require-tag policy assignment."
  value       = azurerm_resource_group_policy_assignment.require_tag.id
}
