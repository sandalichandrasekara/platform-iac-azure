variable "name_prefix" {
  description = "Prefix applied to policy assignment names."
  type        = string
}

variable "location" {
  description = "Azure region (required for policy assignments with identities)."
  type        = string
}

variable "resource_group_id" {
  description = "Scope for the policy assignments."
  type        = string
}

variable "allowed_locations" {
  description = "Regions resources are permitted in."
  type        = list(string)
  default     = ["eastus", "eastus2"]
}

variable "required_tag" {
  description = "Tag name that every resource group must carry."
  type        = string
  default     = "environment"
}
