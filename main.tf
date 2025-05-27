terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
}

provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false  # ✅ Allows Terraform to delete resource groups with nested resources
    }
  }
  subscription_id = var.subscription_id
}

module "vm_module" {
  source              = "./vm_module"
  resource_group_name = var.resource_group_name
  vm_count            = var.vm_count
  nsg_name            = var.nsg_name
  private_ips         = var.private_ips
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  environment         = var.environment
  owner               = var.owner
  subscription_id     = var.subscription_id
  location            = var.location
  address_space       = var.address_space
  subnet_prefixes     = var.subnet_prefixes
  vnet_name           = var.vnet_name
    subnet_name         = var.subnet_name
}