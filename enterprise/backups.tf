resource "azurerm_storage_account" "backups" {
  count = var.create.backups ? 1 : 0

  name                     = "${var.resource_group}-backups"
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  tags                     = local.default_tags
}