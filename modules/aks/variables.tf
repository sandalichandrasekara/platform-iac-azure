variable "name_prefix" {
  description = "Prefix applied to AKS resource names."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the cluster."
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID, used to grant the AGIC add-on identity Reader."
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes control plane version."
  type        = string
  default     = "1.29"
}

variable "availability_zones" {
  description = "Zones the node pools are spread across for resilience."
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "aks_admin_group_object_ids" {
  description = "Azure AD group object IDs granted cluster-admin (break-glass). Local accounts are disabled, so this must be set to retain access."
  type        = list(string)
  default     = []
}

variable "aks_subnet_id" {
  description = "Subnet ID for the node pools."
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Container Insights."
  type        = string
}

variable "acr_id" {
  description = "ACR resource ID to grant the kubelet AcrPull on."
  type        = string
}

variable "gateway_id" {
  description = "Application Gateway resource ID for the AGIC add-on. Empty disables AGIC."
  type        = string
  default     = ""
}

variable "system_node_pool" {
  description = "System node pool sizing."
  type = object({
    vm_size    = string
    node_count = number
  })
  default = {
    vm_size    = "Standard_D2s_v5"
    node_count = 2
  }
}

variable "user_node_pool" {
  description = "User (workload) node pool sizing and autoscale bounds."
  type = object({
    vm_size   = string
    min_count = number
    max_count = number
  })
  default = {
    vm_size   = "Standard_D4s_v5"
    min_count = 2
    max_count = 6
  }
}

variable "service_cidr" {
  description = "CIDR for Kubernetes service IPs (must not overlap the VNet)."
  type        = string
  default     = "10.100.0.0/16"
}

variable "dns_service_ip" {
  description = "IP within service_cidr used by kube-dns."
  type        = string
  default     = "10.100.0.10"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
