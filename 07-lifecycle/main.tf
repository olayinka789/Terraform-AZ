resource "azurerm_resource_group" "example" {
  name     = "${var.environment}-resources"
  location = var.location

  tags = { 
    environment = var.resource_tags.environment        
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    # ignore_changes = [tags]

    precondition {
      condition     = contains(var.allowed_connections, var.location)
      error_message = "The specified location is not in the list of allowed locations."
    }
  }
}


  
resource "azurerm_storage_account" "example" {
   
  #count = length(var.storage_account_name)
  for_each = var.storage_account_name
  #name = var.storage_account_name(count.index)
  name                     = each.key
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}
