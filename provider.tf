terraform {
  backend "remote" {
    organization = "SivajiRaavi"  # Replace with your Terraform Cloud organization name

    workspaces {
      name = "terratest-azure-vnet-poc"  # Replace with your workspace name
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "abd34832-7708-43f9-a480-e3b7a87b41d7" #var.subscription_id
  #   client_id       = var.client_id
  #   client_secret   = var.client_secret
  #   tenant_id       = var.tenant_id
}
