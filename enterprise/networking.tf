resource "azurerm_virtual_network" "company" {
  name                = "${var.company_name}-vnet"
  resource_group_name = azurerm_resource_group.company.name
  location            = azurerm_resource_group.company.location
  address_space       = [""]

  tags = local.default_tags
}

resource "azurerm_public_ip" "vpn_public_ip" {
  count = var.create.vpn ? 1 : 0

  name                = "${var.company_name}-vpn-public-ip"
  resource_group_name = azurerm_resource_group.company.name
  location            = azurerm_resource_group.company.location
  allocation_method   = "Static"

  tags = local.default_tags
}