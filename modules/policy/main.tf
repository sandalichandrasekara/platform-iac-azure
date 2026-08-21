# Built-in policy definitions referenced by their well-known GUIDs.
locals {
  allowed_locations_def = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  require_tag_def       = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
}

# Restrict where resources may be deployed.
resource "azurerm_resource_group_policy_assignment" "allowed_locations" {
  name                 = "${var.name_prefix}-allowed-locations"
  resource_group_id    = var.resource_group_id
  policy_definition_id = local.allowed_locations_def
  display_name         = "Allowed locations"

  parameters = jsonencode({
    listOfAllowedLocations = {
      value = var.allowed_locations
    }
  })
}

# Require a governance tag on every resource group in scope.
resource "azurerm_resource_group_policy_assignment" "require_tag" {
  name                 = "${var.name_prefix}-require-tag"
  resource_group_id    = var.resource_group_id
  policy_definition_id = local.require_tag_def
  display_name         = "Require ${var.required_tag} tag on resource groups"

  parameters = jsonencode({
    tagName = {
      value = var.required_tag
    }
  })
}
