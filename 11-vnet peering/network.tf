resource "azurerm_resource_group" "az-rg" {
  name     = "az11-rg"
  location = "West Europe"
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "peer1"
  location            = azurerm_resource_group.az-rg.location
  address_space       = ["10.0.0.0/16"]
  resource_group_name = azurerm_resource_group.az-rg.name
}

resource "azurerm_subnet" "subnet1" {
  name                 = "peer-subnet1"
  resource_group_name  = azurerm_resource_group.az-rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.0.0/24"]
}


resource "azurerm_virtual_network" "vnet2" {
  name                = "peer2"
  location            = azurerm_resource_group.az-rg.location
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.az-rg.name
}

resource "azurerm_subnet" "subnet2" {
  name                 = "peer-subnet2"
  resource_group_name  = azurerm_resource_group.az-rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.0.0/24"]
}

resource "azurerm_virtual_network_peering" "peer1-to-peer2" {
  name                      = "peer1-to-peer2"
  resource_group_name       = azurerm_resource_group.az-rg.name
  virtual_network_name      = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id = azurerm_virtual_network.vnet2.id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "peer2-to-peer1" {
  name                      = "peer2-to-peer1"
  resource_group_name       = azurerm_resource_group.az-rg.name
  virtual_network_name      = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id = azurerm_virtual_network.vnet1.id
  allow_forwarded_traffic   = true
}
