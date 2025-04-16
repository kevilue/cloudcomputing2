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

# Check if the SSH key exists
if [ ! -f "$full_ssh_key_path" ]; then
    echo "SSH key not found at $full_ssh_key_path. Please check the path and try again."
    exit 1
fi

# Get the public IP adress of the Azure VM
public_ip=$(terraform -chdir=./terraform output -raw vm_public_ip)
# Create collection name from public IP
collection_name=$(echo "$public_ip" | tr -d '.')
# Set environment variable
export MONGO_COLLECTION="$collection_name"
# Install requirements
pip install -r requirements.txt
# Check MongoDB connection and ask user if they want to create a database/collection for the webapp
python3 db_config.py -collection "$collection_name" -connection_string "$mongodb_connection_string"

# Execute ansible playbook with inventory to configure the vm
ansible-playbook -i ./ansible/node_inventory.ini ./ansible/playbook.yml --private-key $full_ssh_key_path -e "MONGO_URI=$mongodb_connection_string"

# Print the public IP address of the VM
echo "The simpleJokeApp application is now available at: $public_ip"