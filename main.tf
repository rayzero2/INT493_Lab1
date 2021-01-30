provider "azurerm" {
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "INT493"
    storage_account_name = "int493ac"
    container_name       = "terraform-state"
    key                  = "terraform.tfstate"
  }
}


resource "azurerm_resource_group" "INT493" {
    name = "INT493"
    location = "Southeast Asia"
}

resource "azurerm_virtual_network" "INT493_lab1" {
    name = "INT493_lab1-vnet"
    resource_group_name = "INT493"
    location = "Southeast Asia"
    address_space = [ "10.0.0.0/24" ]
}