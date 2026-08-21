variable "name_prefix" {
  description = "Prefix applied to identity resource names."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the managed identity."
  type        = string
}

variable "oidc_issuer_url" {
  description = "OIDC issuer URL of the AKS cluster (enables workload identity federation)."
  type        = string
}

variable "service_account_namespace" {
  description = "Kubernetes namespace of the workload's service account."
  type        = string
  default     = "app"
}

variable "service_account_name" {
  description = "Kubernetes service account name the identity is federated to."
  type        = string
  default     = "workload-sa"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
