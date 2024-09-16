locals {
  default_tags = {
    # environment = var.environment
    company = var.company_name
  }
}

resource "azurerm_resource_group" "company" {
  name     = var.company_name
  location = var.azure_region
}
