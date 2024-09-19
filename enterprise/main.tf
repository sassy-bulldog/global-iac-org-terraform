data "spacelift_current_stack" "this" {}

locals {
  default_tags = {
    "Created-By" = "Spacelift",
    "Stack"      = data.spacelift_current_stack.this.id
    "Managed-By" = "Terraform",
    "Repository" = "global-iac-org-terraform",
    "Company"    = var.company_name,
  }
}

resource "azurerm_resource_group" "this" {
  name     = var.resource_group
  location = var.azure_region
}
