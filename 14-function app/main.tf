resource "azurerm_resource_group" "rg" {
  name     = "14-rg"
  location = "UK South"
}

resource "azurerm_storage_account" "azstorage" {
  name                     = "azfuncstorage14"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_service_plan" "azfunctionapp-asp" {
  name                = "azfunctionapp-asp"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}   

resource "azurerm_linux_function_app" "azfunctionapp" {
  name                = "azfunctionapp14"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  storage_account_name       = azurerm_storage_account.azstorage.name
  storage_account_access_key = azurerm_storage_account.azstorage.primary_access_key
  service_plan_id            = azurerm_service_plan.azfunctionapp-asp.id

  site_config {
    application_stack {
      node_version = "20"
    }
  }
}
