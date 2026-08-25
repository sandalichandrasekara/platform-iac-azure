output "server_fqdn" {
  description = "Fully qualified domain name of the SQL server (resolves privately)."
  value       = azurerm_mssql_server.this.fully_qualified_domain_name
}
