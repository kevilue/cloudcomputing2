output "mongodb_connection_string" {
    value = var.mongodb_connection_string
    description = "MongoDB connection string"
    sensitive = true
}

output "azure_vm_ssh_publickey_location" {
    value = var.azure_vm_ssh_publickey_location
    description = "SSH public key for Azure VM"
}

output "vm_public_ip" {
    value = module.azure.public_ip
    description = "Public IP address of the Azure VM"
}