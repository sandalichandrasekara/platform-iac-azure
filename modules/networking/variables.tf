variable "name_prefix" {
  description = "Prefix applied to all networking resource names (e.g. platform-dev)."
  type        = string
}

variable "location" {
  description = "Azure region."
  type        = string
}

variable "resource_group_name" {
  description = "Resource group the network resources are created in."
  type        = string
}

variable "vnet_address_space" {
  description = "CIDR blocks for the virtual network."
  type        = list(string)
  default     = ["10.20.0.0/16"]
}

variable "subnet_prefixes" {
  description = "CIDR for each purpose-scoped subnet."
  type = object({
    aks               = string
    appgw             = string
    private_endpoints = string
  })
  default = {
    aks               = "10.20.0.0/20"
    appgw             = "10.20.16.0/24"
    private_endpoints = "10.20.17.0/24"
  }
}

variable "tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
