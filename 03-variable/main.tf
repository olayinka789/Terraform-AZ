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
variable "environment" {
  type        = string
  default     = "staging"
  description = "the env type"

}

locals {
  common_tags = {
    Owner       = "Olayinka"
    Project     = "Azure-Terraform"
    Environment = "dev"
    lob         = "IT"
    stage      = "beginner"
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
    environment = local.common_tags.stage
  }
}

output "storage_account_name" {
  value = azurerm_storage_account.test.name
}
