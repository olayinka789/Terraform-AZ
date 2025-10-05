terraform {

 backend "azurerm" {
    resource_group_name  = "tfstate-02rg"
    storage_account_name = "aztf0218518"
    container_name       = "tfstate"
    key                  = "dev.terraform.tfstate"
  }
}
