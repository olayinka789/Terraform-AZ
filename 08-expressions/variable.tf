# String type
variable "environment" {
  type        = string
  description = "Deployment environment (e.g., dev, prod, staging)"
  default     = "dev"
}

# List type
variable "account_names" {
  type        = list(string)
  description = "List of allowed Azure storage accounts"
  default     = ["azterraform11", "azterraform12", "azterraform13"]
}

