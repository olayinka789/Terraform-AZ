
resource "azurerm_storage_account" "test" {
  name                     = "azterraform285"
  resource_group_name      = azurerm_resource_group.test.name
  location                 = azurerm_resource_group.test.location # implicit dependency
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = local.common_tags.environment
  }
}


