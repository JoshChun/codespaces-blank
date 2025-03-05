terraform {
  backend "azurerm" {
    subscription_id = "03e50e49-b267-403d-9df3-0533921b505e"
    resource_group_name   = "rg-tfstate"
    storage_account_name  = "sttfstate5716"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}
