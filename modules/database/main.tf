resource "azurerm_mssql_server" "this" {
  name                          = "${var.name_prefix}-sql"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  version                       = "12.0"
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  # AAD-only auth: no SQL admin password to store or leak.
  azuread_administrator {
    login_username              = var.aad_admin_login
    object_id                   = var.aad_admin_object_id
    azuread_authentication_only = true
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "this" {
  name      = "${var.name_prefix}-db"
  server_id = azurerm_mssql_server.this.id
  sku_name  = var.database_sku
  collation = "SQL_Latin1_General_CP1_CI_AS"

  tags = var.tags
}

resource "azurerm_private_dns_zone" "sql" {
  name                = "privatelink.database.windows.net"
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "sql" {
  name                  = "${var.name_prefix}-sql-dns-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.sql.name
  virtual_network_id    = var.vnet_id
  tags                  = var.tags
}

resource "azurerm_private_endpoint" "sql" {
  name                = "${var.name_prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.name_prefix}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.this.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql"
    private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
  }

  tags = var.tags
}
