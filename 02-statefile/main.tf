terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
        version = "~> 4.8.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "tfstate-02rg"
    storage_account_name = "aztf0218518"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
  required_version = ">=1.9.0"

}
provider "azurerm" {
  features {

  }
} 
resource "azurerm_resource_group" "test" {
  name     = "test-resources"
  location = "UK South"
}

resource "azurerm_storage_account" "test" {
  name                     = "azterraform285"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}
