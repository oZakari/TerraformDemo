terraform {
  backend "azurerm" {
    resource_group_name  = "tfframework-states-rg"
    storage_account_name = "terraformstateszt"
    container_name       = "tfframework-states"
    key                  = "terraform-demo.tfstate"
  }
}