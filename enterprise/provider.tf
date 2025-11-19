# Configure the Microsoft Azure Provider
provider "azurerm" {
  # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  resource_provider_registrations = "none"
  features {}
}

# Entra / Azure AD provider
provider "azuread" {
  # configuration left intentionally minimal; set tenant_id / client creds as needed
}

# AZ API provider for resources not supported in azurerm
provider "azapi" {
  # optional: scope configuration
}

# Microsoft Graph provider (use this for Exchange/Outlook, Defender, Purview, Power Platform where supported)
provider "msgraph" {
  # authenticate via client credentials / environment / managed identity
}
