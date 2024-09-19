resource "azurerm_storage_account" "lake" {
  count = var.create.data_lake ? 1 : 0

  name                     = "${var.resource_group}dls"  # Data Lake Storage
  resource_group_name      = azurerm_resource_group.this.name
  location                 = azurerm_resource_group.this.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = "true"
  tags                     = local.default_tags
}

resource "azurerm_storage_data_lake_gen2_filesystem" "data_lake" {
  count = var.create.data_lake ? 1 : 0

  name               = "${var.resource_group}-data-lake"
  storage_account_id = azurerm_storage_account.lake[count.index].id
  # default_encryption_scope 

#   properties = {
#     hello = "aGVsbG8="
#   }
}