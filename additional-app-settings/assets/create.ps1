
[CmdletBinding()]
param (
  [Parameter(Mandatory)] [string] ${subscription-id},
  [Parameter(Mandatory)] [string] ${resource-group-name},
  [Parameter(Mandatory)] [string] ${app-service-name},
  [Parameter(Mandatory)] [hashtable] ${app-settings}
)

$settings = (${app-settings}.Keys | ForEach-Object { "$($_)=$(${app-settings}[$_])" }) -join " "

az webapp config appsettings set `
  --subscription ${subscription-id} `
  --resource-group ${resource-group-name} `
  --name ${app-service-name} `
  --settings $settings
