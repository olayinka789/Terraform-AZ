locals {
  common_tags = {
    owner       = "Olayinka"
    project     = "Azure-Terraform"
    environment = var.environment
    lob         = "IT"
    stage      = "beginner"
  }
}
