# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    spacelift = {
      source = "spacelift-io/spacelift"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.54.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.7"
    }

    azapi = {
      source  = "azure/azapi"
      version = ">= 2.7"
    }
    # Microsoft Graph / M365 provider (adjust exact source & version per registry)
    msgraph = {
      source  = "Microsoft/msgraph"
      version = ">= 1.0"
    }
  }
}
