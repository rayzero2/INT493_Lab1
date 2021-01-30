terraform {
  backend "azurerm" {
    #these configuration just for local run only, we will override them in Azure Pipeline
    resource_group_name  = "mwp-shared"
    storage_account_name = "mwpterraform"
    container_name       = "mwp-local"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.RESOURCE_GROUP           # Variable
  location = var.RESOURCE_GROUP_LOCATION  # Variable
}

resource "azurerm_app_service_plan" "appserviceplan" {
  name                = "test-appserviceplan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Basic"
    size = "F1"
  }
}#test

resource "azurerm_app_service" "appservice_appapi" {
  name                = "test-appservice"  
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.appserviceplan.id
}#test