variable "subscriptionId" {
  type     = string
  nullable = false
}

variable "appService" {
  type = object({
    name                = string
    resource_group_name = string
  })
}

variable "appSettings" {
  type = map(string)
}
