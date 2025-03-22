variable "subscriptionId" {
  type     = string
  nullable = false
}

variable "appService" {
  type = object({
    # The property id is marked as 'known after apply' during initial creation.
    # This avoids deadlocking the implemented custom refresh mechanism.
    # We parse the id to retrieve name and resource group name.
    id = string
  })
}

variable "appSettings" {
  type = map(string)
}
