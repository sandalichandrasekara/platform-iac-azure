resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.name_prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# Container Insights: node/pod/container telemetry into the workspace.
resource "azurerm_log_analytics_solution" "container_insights" {
  solution_name         = "ContainerInsights"
  location              = var.location
  resource_group_name   = var.resource_group_name
  workspace_resource_id = azurerm_log_analytics_workspace.this.id
  workspace_name        = azurerm_log_analytics_workspace.this.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }

  tags = var.tags
}

resource "azurerm_monitor_action_group" "critical" {
  name                = "${var.name_prefix}-ag-critical"
  resource_group_name = var.resource_group_name
  short_name          = "critical"

  dynamic "email_receiver" {
    for_each = var.alert_email_receivers
    content {
      name          = email_receiver.key
      email_address = email_receiver.value
    }
  }

  tags = var.tags
}
