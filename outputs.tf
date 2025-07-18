# Resource Group Outputs
output "resource_group_name" {
  description = "Name of the created resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the created resource group"
  value       = azurerm_resource_group.main.location
}

# Virtual Network Outputs
output "vnet_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "vnet_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_address_space" {
  description = "Address space of the virtual network"
  value       = azurerm_virtual_network.main.address_space
}

# Public Subnet Outputs
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = azurerm_subnet.public[*].id
}

output "public_subnet_names" {
  description = "Names of the public subnets"
  value       = azurerm_subnet.public[*].name
}

output "public_subnet_cidrs" {
  description = "CIDR blocks of the public subnets"
  value       = azurerm_subnet.public[*].address_prefixes
}

# Private Subnet Outputs
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = azurerm_subnet.private[*].id
}

output "private_subnet_names" {
  description = "Names of the private subnets"
  value       = azurerm_subnet.private[*].name
}

output "private_subnet_cidrs" {
  description = "CIDR blocks of the private subnets"
  value       = azurerm_subnet.private[*].address_prefixes
}

# NAT Gateway Outputs
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = azurerm_nat_gateway.main.id
}

output "nat_gateway_public_ip" {
  description = "Public IP address of the NAT Gateway"
  value       = azurerm_public_ip.nat_gateway.ip_address
}

# Network Security Group Outputs
output "public_nsg_ids" {
  description = "IDs of the public network security groups"
  value       = azurerm_network_security_group.public[*].id
}

output "private_nsg_ids" {
  description = "IDs of the private network security groups"
  value       = azurerm_network_security_group.private[*].id
}

# Route Table Outputs
output "public_route_table_ids" {
  description = "IDs of the public route tables"
  value       = azurerm_route_table.public[*].id
}

output "private_route_table_ids" {
  description = "IDs of the private route tables"
  value       = azurerm_route_table.private[*].id
}
