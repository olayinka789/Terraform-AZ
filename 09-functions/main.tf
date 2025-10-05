locals {
  formatted_name   = lower(replace(var.project_name, " ", "-"))
  merged_tags      = merge(var.default_tags, var.environment_tags)
  storage_formated = replace(replace(lower(substr(var.storage_account_name, 0, 23)), " ", ""), "#", "")
  formatted_ports  = split(",", (var.allowed_ports))
  nsg_rules = [for ports in local.formatted_ports : {
    name        = "port-${ports}"
    port        = ports
    description = "Allow trasffic on ${ports}"
    }
  ]
  vm_sizes = lookup(var.vm_sizes, var.environment, lower("dev"))


  user_location    = ["UK South", "West Europe", "North Europe"]
  default_location = ["centralus"]
  unique_location  = toset(concat(local.user_location, local.default_location))

monthly_costs = [-50, 100, 75, 200]
postive_costs = [for cost in local.monthly_costs : 
abs(cost)]
max_cost = max(local.postive_costs...)

current_time = timestamp()
resource_name = formatdate("YYYYMMDD-HHMMSS", local.current_time)
tag_date = formatdate("DD-MM-YYYY", local.current_time)
}

resource "azurerm_resource_group" "rg" {
  name     = "${local.formatted_name}-rg"
  location = "UK South"

  tags = local.merged_tags
}

# Create Network Security Group
resource "azurerm_network_security_group" "example" {
  name                = "${local.formatted_name}-nsg"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Here's where we need the dynamic block
  dynamic "security_rule" {
    for_each = local.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value.port
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      description                = security_rule.value.description
    }
  }
}

resource "azurerm_storage_account" "example" {

  name                     = local.storage_formated
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.merged_tags
}


output "resource_group_name" {
  value = azurerm_resource_group.rg.name

}
output "storage_account_name" {
  value = azurerm_storage_account.example.name
}

output "nsg_rules" {
  value = local.nsg_rules
}

output "security_name" {
  value = azurerm_network_security_group.example.name
}

output "vm_size" {
  value = local.vm_sizes
}

output "backup" {
  value = var.backup_name
}

output "credential" {
  value     = var.credential
  sensitive = true
}

output "unique_location" {
  value = local.unique_location
}

output "max_cost" {
  value = local.max_cost
}

output "postive_costs" {
  value = local.postive_costs
}

output "resource_tag" {
  value = local.tag_date
  
}

