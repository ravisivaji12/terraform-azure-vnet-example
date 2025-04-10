terraform {
  backend "azurerm" {
    resource_group_name   = "rg-terraform-state"
    storage_account_name  = "sttfstate123s"
    container_name        = "terraform-state"
    key                   = "prod/terraform.tfstate"
  }
}
provider "azurerm" {
  features {}
  subscription_id = "abd34832-7708-43f9-a480-e3b7a87b41d7" #var.subscription_id
  #   client_id       = var.client_id
  #   client_secret   = var.client_secret
  #   tenant_id       = var.tenant_id
}
