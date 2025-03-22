data "azurerm_linux_web_app" "appService" {
  resource_group_name = local.resourceGroupName
  name                = local.appServiceName
}

locals {
  currentAppSettings = data.azurerm_linux_web_app.appService.app_settings

  areAppSettingsInDesiredState = alltrue([
    for desiredKey, desiredValue in var.appSettings :
    contains(keys(local.currentAppSettings), desiredKey) ?
    local.currentAppSettings[desiredKey] == desiredValue :
    false # We can't use the logical operator '&&' here due to a bug in short-circuiting.
  ])
}

resource "value_replaced_when" "driftDetected" {
  condition = !local.areAppSettingsInDesiredState
}
