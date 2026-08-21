# Ship the logs Container Insights doesn't cover: AKS control-plane/audit,
# App Gateway WAF/access, and Key Vault audit events.

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "${local.name_prefix}-aks-diag"
  target_resource_id         = module.aks.cluster_id
  log_analytics_workspace_id = module.observability.workspace_id
  enabled_log { category_group = "allLogs" }
}

resource "azurerm_monitor_diagnostic_setting" "app_gateway" {
  name                       = "${local.name_prefix}-appgw-diag"
  target_resource_id         = module.app_gateway.gateway_id
  log_analytics_workspace_id = module.observability.workspace_id
  enabled_log { category_group = "allLogs" }
}

resource "azurerm_monitor_diagnostic_setting" "key_vault" {
  name                       = "${local.name_prefix}-kv-diag"
  target_resource_id         = module.key_vault.key_vault_id
  log_analytics_workspace_id = module.observability.workspace_id
  enabled_log { category_group = "audit" }
}

resource "azurerm_monitor_metric_alert" "aks_node_cpu" {
  name                = "${local.name_prefix}-aks-node-cpu"
  resource_group_name = azurerm_resource_group.this.name
  scopes              = [module.aks.cluster_id]
  description         = "Average node CPU across the cluster exceeded 80%."
  severity            = 2
  frequency           = "PT5M"
  window_size         = "PT15M"

  criteria {
    metric_namespace = "Microsoft.ContainerService/managedClusters"
    metric_name      = "node_cpu_usage_percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = module.observability.action_group_id
  }
}
