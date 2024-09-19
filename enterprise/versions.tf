# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.2.0"
    }
  }
}
