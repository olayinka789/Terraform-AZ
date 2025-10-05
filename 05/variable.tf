variable "environment" {
  type        = string
  default     = "staging"
  description = "the env type"

}
variable "disk_size" {
  type        = number
  default     = 30
  description = "The size of the OS disk in GB"

}

variable "is_delete" {
  type        = bool
  default     = true
  description = "Whether to delete the OS disk when the VM is deleted"
}

variable "allowed_connections" {
  type        = list(string)
  default     = ["West Europe", "North Europe", "UK South"]
  description = "List of allowed inbound connections"
}

variable "resource_tags" {
  type = map(string)
  default = {
    owner       = "Olayinka"
    environment = "staging"
    project     = "Azure-Terraform"  
    managed_by   = "Terraform"
}
}

# Tuple type
variable "network_config" {
  type        = tuple([string, string, number])
  description = "Network configuration (VNET address, subnet address, subnet mask)"
  default     = ["10.0.0.0/16", "10.0.2.0", 24]
}


variable "allowed_vm_sizes" {
  type        = list(string)
  description = "Allowed VM sizes"
  default     = ["Standard_B1s", "Standard_B2s", "Standard_B2ms"]
}

# object type
variable "vm_config" {
  type = object({
    size      = string
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "Virtual machine configuration"
  default = {
    size      = "Standard_B1s"   # 1 vCPU, 1 GiB RAM (good entry-level option)
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

