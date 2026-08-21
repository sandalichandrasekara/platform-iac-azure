resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.name_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.name_prefix}-aks"
  kubernetes_version  = var.kubernetes_version

  # Secretless pod-to-Azure auth.
  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  # AAD-integrated authorization only; no local admin kubeconfig to leak.
  local_account_disabled = true

  # System pool runs cluster-critical add-ons only (CriticalAddonsOnly taint),
  # spread across availability zones for resilience.
  default_node_pool {
    name                         = "system"
    vm_size                      = var.system_node_pool.vm_size
    node_count                   = var.system_node_pool.node_count
    vnet_subnet_id               = var.aks_subnet_id
    orchestrator_version         = var.kubernetes_version
    only_critical_addons_enabled = true
    zones                        = var.availability_zones
    node_labels = {
      "nodepool-type" = "system"
    }
  }

  identity {
    type = "SystemAssigned"
  }

  # Azure RBAC for Kubernetes authorization; break-glass admin via AAD group.
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = var.aks_admin_group_object_ids
  }

  network_profile {
    network_plugin    = "azure"
    network_policy    = "azure"
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
  }

  oms_agent {
    log_analytics_workspace_id = var.log_analytics_workspace_id
  }

  # Compliance-as-code enforcement inside the cluster.
  azure_policy_enabled = true

  dynamic "ingress_application_gateway" {
    for_each = var.gateway_id == "" ? [] : [1]
    content {
      gateway_id = var.gateway_id
    }
  }

  tags = var.tags
}

# User workload pool with the cluster autoscaler enabled (HPA scales pods, this
# scales the nodes underneath them).
resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.this.id
  vm_size               = var.user_node_pool.vm_size
  vnet_subnet_id        = var.aks_subnet_id
  orchestrator_version  = var.kubernetes_version
  mode                  = "User"
  zones                 = var.availability_zones

  enable_auto_scaling = true
  min_count           = var.user_node_pool.min_count
  max_count           = var.user_node_pool.max_count

  node_labels = {
    "nodepool-type" = "user"
  }

  tags = var.tags
}

# Let the kubelet pull images from ACR without a registry secret.
resource "azurerm_role_assignment" "acr_pull" {
  scope                            = var.acr_id
  role_definition_name             = "AcrPull"
  principal_id                     = azurerm_kubernetes_cluster.this.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}

# The AGIC add-on runs under its own managed identity. It must be able to
# program the Application Gateway (Contributor) and read the resource group;
# without these the ingress add-on comes up but never configures the gateway.
resource "azurerm_role_assignment" "agic_gateway" {
  count                = var.gateway_id == "" ? 0 : 1
  scope                = var.gateway_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_kubernetes_cluster.this.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}

resource "azurerm_role_assignment" "agic_rg_reader" {
  count                = var.gateway_id == "" ? 0 : 1
  scope                = var.resource_group_id
  role_definition_name = "Reader"
  principal_id         = azurerm_kubernetes_cluster.this.ingress_application_gateway[0].ingress_application_gateway_identity[0].object_id
}
