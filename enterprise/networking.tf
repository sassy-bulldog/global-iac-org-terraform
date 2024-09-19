resource "azurerm_virtual_network" "company" {
  name                = "${var.resource_group}-vnet"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  address_space       = [var.azure_vnet_cidr_block]

  tags = local.default_tags
}

resource "azurerm_public_ip" "vpn_public_ip" {
  count = var.create.vpn ? 1 : 0

  name                = "${var.resource_group}-vpn-public-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"

  tags = local.default_tags
}