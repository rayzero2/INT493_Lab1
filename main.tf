provider "azurerm" {
  features {}
}

terraform {
       backend "remote" {
         # The name of your Terraform Cloud organization.
         organization = "INT493"

         # The name of the Terraform Cloud workspace to store Terraform state files in.
         workspaces {
           name = "INT493_lab1"
         }
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