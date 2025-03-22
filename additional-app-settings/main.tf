resource "terraform_data" "appSettings" {
  triggers_replace = {
    subscriptionId = var.subscriptionId
    appService     = var.appService
    appSettings    = var.appSettings
  }

  input = {
    subscriptionId    = var.subscriptionId
    resourceGroupName = var.appService.resource_group_name
    appServiceName    = var.appService.name
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
