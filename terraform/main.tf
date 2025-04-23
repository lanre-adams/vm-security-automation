
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "vm_sec_rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_policy_definition" "enforce_tags" {
  name         = "enforce-tags-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Enforce resource tagging"
  policy_rule  = file("${path.module}/policies/enforce_tags.json")
  parameters   = jsonencode({ requiredTags = ["Environment", "Owner", "CostCenter"] })
}

resource "azurerm_policy_definition" "restrict_locations" {
  name         = "restrict-locations-policy"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Restrict resource locations"
  policy_rule  = file("${path.module}/policies/restrict_locations.json")
  parameters   = jsonencode({ allowedLocations = ["East US", "West Europe", "Central India"] })
}

resource "azurerm_policy_assignment" "tags_assignment" {
  name                 = "enforce-tags-assignment"
  policy_definition_id = azurerm_policy_definition.enforce_tags.id
  scope                = azurerm_resource_group.vm_sec_rg.id
}

resource "azurerm_policy_assignment" "location_assignment" {
  name                 = "restrict-locations-assignment"
  policy_definition_id = azurerm_policy_definition.restrict_locations.id
  scope                = azurerm_resource_group.vm_sec_rg.id
}
