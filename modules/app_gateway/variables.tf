variable "name_prefix" {
  description = "Prefix applied to gateway resource names."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the gateway."
  type        = string
}

variable "subnet_id" {
  description = "Dedicated Application Gateway subnet ID."
  type        = string
}

variable "capacity" {
  description = "Autoscale bounds for the gateway (v2 SKU)."
  type = object({
    min = number
    max = number
  })
  default = {
    min = 1
    max = 3
  }
}

variable "waf_mode" {
  description = "WAF policy mode: Detection or Prevention."
  type        = string
  default     = "Prevention"
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
