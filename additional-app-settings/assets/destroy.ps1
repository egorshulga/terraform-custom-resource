[CmdletBinding()]
param (
  [Parameter(Mandatory)] [string] ${subscription-id},
  [Parameter(Mandatory)] [string] ${resource-group-name},
  [Parameter(Mandatory)] [string] ${app-service-name},
  [Parameter(Mandatory)] [hashtable] ${app-settings}
)

$settings = ${app-settings}.Keys -join " "

az webapp config appsettings delete `
  --subscription ${subscription-id} `
  --resource-group ${resource-group-name} `
  --name ${app-service-name} `
  --setting-names $settings
