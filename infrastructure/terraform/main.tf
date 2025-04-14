# Providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

# Azure provider configuration
provider "azurerm" {
  features {}
  resource_provider_registrations = "none"

  subscription_id = var.azure_sub_id
  client_id       = var.azure_client_id
  client_secret   = var.azure_client_secret
  tenant_id       = var.azure_tenant_id
}

# Configure Azure module
module "azure" {
    source = "./modules/azure"
    ssh_publickey_location = var.azure_vm_ssh_publickey_location
}

# Build ansible config from template
resource "local_file" "ansible_inventory" {
  content = templatefile("../ansible/inventory.tmpl", {
    public_ip = module.azure.public_ip
    public_user = "azureuser"
  })
  filename = "../ansible/node_inventory.ini"
  file_permission = "0644"
}