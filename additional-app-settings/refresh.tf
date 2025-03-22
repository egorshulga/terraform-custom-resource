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

data "validation_warnings" "appSettingsAreNotInDesiredState" {
  dynamic "warning" {
    for_each = var.appSettings
    iterator = each
    content {
      condition = !contains(keys(local.currentAppSettings), each.key)
      summary   = "AppSetting ${each.key} is not present, so it will be added"
    }
  }

  dynamic "warning" {
    for_each = var.appSettings
    iterator = each
    content {
      condition = (
        contains(keys(local.currentAppSettings), each.key) ?
        local.currentAppSettings[each.key] != each.value :
        false
      )
      summary = "AppSetting ${each.key} does not have desired value, so it will be updated"
    }
  }
}

resource "value_replaced_when" "driftDetected" {
  condition = !local.areAppSettingsInDesiredState
}
