# Configure the Microsoft Azure Provider
terraform {
  backend "azurerm" {
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>3.4"
    }
  }
}
provider "azurerm" {
  features {}
}