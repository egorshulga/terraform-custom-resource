terraform {
  required_version = ">= 1.11.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.24.0"
    }
    value = {
      source  = "pseudo-dynamic/value"
      version = "~> 0.5.5"
    }
    validation = {
      source  = "tlkamp/validation"
      version = "~> 1.1.3"
    }
  }
}
