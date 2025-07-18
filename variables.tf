# Resource Configuration Variables
variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "East US"
  
  validation {
    condition = contains([
      "East US", "East US 2", "West US", "West US 2", "West US 3",
      "Central US", "North Central US", "South Central US"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Common Tags
variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default = {
    Environment = "Development"
    Project     = "sp-terraform-project1"
    ManagedBy   = "Terraform"
  }
}

variable "resource_group_name" {
  description = "Name of the resource group to create"
  type        = string
  default     = "resource-group"
}

# Network Configuration Variables
variable "vnet_name" {
  description = "Name of the virtual network"
  type        = string
  default     = "sp-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

# NSG Rules Configuration
variable "nsg_rules" {
  description = "Network security group rules"
  type = map(object({
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
}