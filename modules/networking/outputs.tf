output "vnet_id" {
  description = "Resource ID of the virtual network."
  value       = azurerm_virtual_network.this.id
}

output "vnet_name" {
  description = "Name of the virtual network."
  value       = azurerm_virtual_network.this.name
}

output "aks_subnet_id" {
  description = "Subnet ID for the AKS node pools."
  value       = azurerm_subnet.aks.id
}

output "appgw_subnet_id" {
  description = "Subnet ID for the Application Gateway."
  value       = azurerm_subnet.appgw.id
}

output "private_endpoints_subnet_id" {
  description = "Subnet ID for private endpoints."
  value       = azurerm_subnet.private_endpoints.id
}
