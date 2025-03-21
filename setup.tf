data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "resourceGroup" {
  name     = "test"
  location = "westeurope"
}

resource "azurerm_service_plan" "appServicePlan" {
  name                = "app-service-plan"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  location            = azurerm_resource_group.resourceGroup.location

  os_type  = "Linux"
  sku_name = "P1v2"
}
