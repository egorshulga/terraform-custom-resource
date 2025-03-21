module "appService1AppSettings" {
  source = "./additional-app-settings"

  subscriptionId = data.azurerm_client_config.current.subscription_id
  appService     = azurerm_linux_web_app.appService1
  appSettings = {
    CALLEE = azurerm_linux_web_app.appService2.identity[0].principal_id
  }
}

module "appService2AppSettings" {
  source = "./additional-app-settings"

  subscriptionId = data.azurerm_client_config.current.subscription_id
  appService     = azurerm_linux_web_app.appService2
  appSettings = {
    CALLER = azurerm_linux_web_app.appService1.identity[0].principal_id
  }
}
