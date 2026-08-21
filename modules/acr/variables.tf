variable "name" {
  description = "ACR name."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the registry."
  type        = string
}

variable "sku" {
  description = "Registry SKU."
  type        = string
  default     = "Premium"
}

variable "vnet_id" {
  description = "VNet ID to link the private DNS zone to."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID hosting the ACR private endpoint."
  type        = string
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
