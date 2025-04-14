#!/bin/bash

# Execute terraform
cd terraform
terraform init && terraform plan && terraform apply
terraform refresh
cd ..

# Variable for mongo db connection string, collected from terraform
mongodb_connection_string=$(terraform -chdir=./terraform output -raw mongodb_connection_string)
# Set the environment variable for MongoDB connection string
export MONGO_URI="$mongodb_connection_string"

# Get ssh key name from terraform variables
ssh_key_name=$(terraform -chdir=./terraform output -raw azure_vm_ssh_publickey_location | cut -d "." -f2 | cut -d "/" -f2)
# Build full path to ssh key
full_ssh_key_path="/home/azureuser/.ssh/$ssh_key_name"

# Execute ansible playbook with inventory to configure the vm
ansible-playbook -i ./ansible/node_inventory.ini ./ansible/playbook.yml --private-key $full_ssh_key_path -e "MONGO_URI=$mongodb_connection_string"

# Print the public IP address of the VM
public_ip=$(terraform -chdir=./terraform output -raw vm_public_ip)
echo "The simpleJokeApp application is now available at: $public_ip"