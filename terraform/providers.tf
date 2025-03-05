terraform {
    required_providers {
      azurerm = {
        source = "hashicorp/azurerm"
        version = "~> 3.0"
      }
    }
}

provider "azurerm" {
    features {}
    subscription_id = "03e50e49-b267-403d-9df3-0533921b505e"
}