locals {
  appService        = provider::azurerm::parse_resource_id(var.appService.id)
  resourceGroupName = local.appService.resource_group_name
  appServiceName    = local.appService.resource_name
}

resource "terraform_data" "appSettings" {
  triggers_replace = {
    subscriptionId        = var.subscriptionId
    resourceGroupName     = local.resourceGroupName
    appServiceName        = local.appServiceName
    appSettings           = var.appSettings
    driftDetectionTrigger = value_replaced_when.driftDetected.value
  }

  input = {
    subscriptionId    = var.subscriptionId
    resourceGroupName = local.resourceGroupName
    appServiceName    = local.appServiceName
    appSettings       = jsonencode(var.appSettings)
  }

  provisioner "local-exec" {
    when        = create
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOT
      ${path.module}/assets/create.ps1 `
        -subscription-id $env:subscriptionId `
        -resource-group-name $env:resourceGroupName `
        -app-service-name $env:appServiceName `
        -app-settings ($env:appSettings | ConvertFrom-Json -AsHashtable)
    EOT
    environment = self.input
    quiet       = true # Silences printing of the invoked command. All other output is not silenced.
  }

  provisioner "local-exec" {
    when        = destroy
    interpreter = ["pwsh", "-Command"]
    command     = <<-EOT
      ${path.module}/assets/destroy.ps1 `
        -subscription-id $env:subscriptionId `
        -resource-group-name $env:resourceGroupName `
        -app-service-name $env:appServiceName `
        -app-settings ($env:appSettings | ConvertFrom-Json -AsHashtable)
    EOT
    environment = self.input
    quiet       = true
    on_failure  = continue
  }
}
