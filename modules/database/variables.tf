variable "name_prefix" {
  description = "Prefix applied to database resource names."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the database."
  type        = string
}

variable "vnet_id" {
  description = "VNet ID to link the private DNS zone to."
  type        = string
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID hosting the SQL private endpoint."
  type        = string
}

variable "aad_admin_login" {
  description = "Azure AD group/user display name set as SQL admin."
  type        = string
}

variable "aad_admin_object_id" {
  description = "Object ID of the Azure AD admin principal."
  type        = string
}

variable "database_sku" {
  description = "SKU for the database (e.g. S0, GP_S_Gen5_2)."
  type        = string
  default     = "S0"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
