# Variables for environment

# Azure
variable "azure_sub_id" {
  description = "Azure subscription ID"
  type        = string
}
variable "azure_tenant_id" {
    description = "Azure tenant ID"
    type        = string
}
variable "azure_client_id" {
    description = "Azure client ID"
    type        = string
}
variable "azure_client_secret" {
    description = "Azure client secret"
    type        = string
    sensitive   = true
}
variable "azure_vm_ssh_publickey_location" {
    description = "SSH public key for Azure VM"
    type        = string
}

# VM database config
variable "mongodb_connection_string" {
    description = "MongoDB connection string"
    type        = string
    sensitive   = true
}