output "acr_id" {
  description = "Resource ID of the container registry."
  value       = azurerm_container_registry.this.id
}

output "acr_name" {
  description = "Name of the container registry."
  value       = azurerm_container_registry.this.name
}

output "login_server" {
  description = "Registry login server (used by CI and image references)."
  value       = azurerm_container_registry.this.login_server
}
