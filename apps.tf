
resource "random_uuid" "appService1" {} # For unique name.

resource "azurerm_linux_web_app" "appService1" {
  name                = "app-service-${random_uuid.appService1.result}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  service_plan_id     = azurerm_service_plan.appServicePlan.id

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    NORMAL_SETTING_1 = 42
  }

  lifecycle {
    ignore_changes = [app_settings["CALLEE"]]
  }
}

resource "random_uuid" "appService2" {} # For unique name.

resource "azurerm_linux_web_app" "appService2" {
  name                = "app-service-${random_uuid.appService2.result}"
  location            = azurerm_resource_group.resourceGroup.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
  service_plan_id     = azurerm_service_plan.appServicePlan.id

  site_config {}

  identity {
    type = "SystemAssigned"
  }

  app_settings = {
    NORMAL_SETTING_2 = 43
  }
  
  lifecycle {
    ignore_changes = [app_settings["CALLER"]]
  }
}
