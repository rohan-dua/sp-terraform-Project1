terraform {
  backend "azurerm" {
   storage_account_name = "tflockstoragerohan"
   container_name = "tflockstoragerohancon1"
   resource_group_name = "tf-lock"
   key = "sp-terraform-project1/terraform.tfstate"   
 }
}

provider "azurerm" {
    features {}
}