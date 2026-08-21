variable "name_prefix" {
  description = "Prefix applied to observability resource names."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for observability resources."
  type        = string
}

variable "log_retention_days" {
  description = "Retention period for the Log Analytics workspace."
  type        = number
  default     = 30
}

variable "alert_email_receivers" {
  description = "Map of receiver name => email address for the Action Group."
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
