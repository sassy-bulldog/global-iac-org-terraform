resource "azurerm_storage_account" "backups" {
  count = var.create.backups ? 1 : 0

  name                     = "${var.company_name}-backups"
  resource_group_name      = azurerm_resource_group.company.name
  location                 = azurerm_resource_group.company.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.default_tags
}