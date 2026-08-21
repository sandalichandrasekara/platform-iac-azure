variable "name" {
  description = "Key Vault name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the vault."
  type        = string
}

variable "tenant_id" {
  description = "Azure AD tenant ID."
  type        = string
}

variable "vnet_id" {
  description = "VNet ID to link the private DNS zone to."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID hosting the Key Vault private endpoint."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
