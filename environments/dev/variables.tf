variable "project" {
  description = "Short project identifier used in resource names."
  type        = string
  default     = "platform"
}

variable "environment" {
  description = "Environment name (dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "acr_name" {
  description = "Globally unique ACR name."
  type        = string
}

variable "key_vault_name" {
  description = "Globally unique Key Vault name."
  type        = string
}

variable "sql_aad_admin_login" {
  description = "Display name of the Azure AD SQL admin group/user."
  type        = string
}

variable "sql_aad_admin_object_id" {
  description = "Object ID of the Azure AD SQL admin principal."
  type        = string
}

variable "alert_email_receivers" {
  description = "Map of name => email for Action Group alert routing."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Base tags applied to every resource."
  type        = map(string)
  default     = {}
}
