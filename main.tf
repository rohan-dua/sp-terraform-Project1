# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = var.vnet_name
  address_space       = var.vnet_address_space
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags
}

# Public IP for NAT Gateway
resource "azurerm_public_ip" "nat_gateway" {
  name                = "${var.environment}-nat-gateway-pip"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  allocation_method   = "Static"
  sku                = "Standard"
  zones              = ["1"]
  tags               = var.tags
}

# NAT Gateway
resource "azurerm_nat_gateway" "main" {
  name                    = "${var.environment}-nat-gateway"
  location                = azurerm_resource_group.main.location
  resource_group_name     = azurerm_resource_group.main.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 10
  zones                   = ["1"]
  tags                    = var.tags
}

# Associate Public IP with NAT Gateway
resource "azurerm_nat_gateway_public_ip_association" "main" {
  nat_gateway_id       = azurerm_nat_gateway.main.id
  public_ip_address_id = azurerm_public_ip.nat_gateway.id
}

# Public Subnets
resource "azurerm_subnet" "public" {
  count                = length(var.public_subnet_cidrs)
  name                 = "${var.environment}-public-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.public_subnet_cidrs[count.index]]
}

# Private Subnets
resource "azurerm_subnet" "private" {
  count                = length(var.private_subnet_cidrs)
  name                 = "${var.environment}-private-subnet-${count.index + 1}"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = [var.private_subnet_cidrs[count.index]]
}

# Associate NAT Gateway with Private Subnets
resource "azurerm_subnet_nat_gateway_association" "private" {
  count          = length(azurerm_subnet.private)
  subnet_id      = azurerm_subnet.private[count.index].id
  nat_gateway_id = azurerm_nat_gateway.main.id
}

# Network Security Groups for Public Subnets
resource "azurerm_network_security_group" "public" {
  count               = length(azurerm_subnet.public)
  name                = "${var.environment}-public-nsg-${count.index + 1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# Network Security Groups for Private Subnets
resource "azurerm_network_security_group" "private" {
  count               = length(azurerm_subnet.private)
  name                = "${var.environment}-private-nsg-${count.index + 1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  dynamic "security_rule" {
    for_each = var.nsg_rules
    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}

# Associate NSGs with Public Subnets
resource "azurerm_subnet_network_security_group_association" "public" {
  count                     = length(azurerm_subnet.public)
  subnet_id                 = azurerm_subnet.public[count.index].id
  network_security_group_id = azurerm_network_security_group.public[count.index].id
}

# Associate NSGs with Private Subnets
resource "azurerm_subnet_network_security_group_association" "private" {
  count                     = length(azurerm_subnet.private)
  subnet_id                 = azurerm_subnet.private[count.index].id
  network_security_group_id = azurerm_network_security_group.private[count.index].id
}

# Route Tables for Public Subnets
resource "azurerm_route_table" "public" {
  count               = length(azurerm_subnet.public)
  name                = "${var.environment}-public-rt-${count.index + 1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  route {
    name           = "internet"
    address_prefix = "0.0.0.0/0"
    next_hop_type  = "Internet"
  }
}

# Route Tables for Private Subnets
resource "azurerm_route_table" "private" {
  count               = length(azurerm_subnet.private)
  name                = "${var.environment}-private-rt-${count.index + 1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = var.tags

  # NAT Gateway handles internet routing automatically for associated subnets
  # Custom routes can be added here as needed
}

# Associate Route Tables with Public Subnets
resource "azurerm_subnet_route_table_association" "public" {
  count          = length(azurerm_subnet.public)
  subnet_id      = azurerm_subnet.public[count.index].id
  route_table_id = azurerm_route_table.public[count.index].id
}

# Associate Route Tables with Private Subnets
resource "azurerm_subnet_route_table_association" "private" {
  count          = length(azurerm_subnet.private)
  subnet_id      = azurerm_subnet.private[count.index].id
  route_table_id = azurerm_route_table.private[count.index].id
}
