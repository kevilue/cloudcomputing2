# cloudcomputing2
Repository for my project work for the lecture "Cloud Computing II" at the Baden-Wuerttemberg Cooperative State University (DHBW) Stuttgart.

This project uses HashiCorp Terraform and Ansible to create infrastructure with Microsoft Azure as Infrastructure as a Service (IaaS) and deploy a simple Python-webapp called simpleJokeApp.
> [!WARNING]
> Since IT-Security is not the subject of this lecture, no protection from potential threats and hazards caused by this project is guaranteed.

# Execution/deployment requirements
HashiCorp Terraform, Ansible and python3 with pip. Also requires the file _terraform.tfvars_ (see [infrastructure](#infrastructure)).

# simpleJokeApp
This is a clone of the [simpleJokeApp GitHub repository](https://github.com/kevilue/simpleJokeApp). It is not used by the infrastructure, since Ansible directly clones the repo from GitHub. It is included in this repository for completeness.

# infrastructure
This folder contains the source files for Ansible and Terraform. To execute the required steps for creating the infrastructure and deploying the simpleJokeApp, the following actions are required:

1. Create file _terraform.tfvars_ inside folder [/infrastructure/terraform/](/infrastructure/terraform/) with the following content:
```terraform
mongodb_connection_string = "YOUR_CONNECTION_STRING"
azure_client_id = "YOUR_CLIENT_ID"
azure_client_secret = "YOUR_CLIENT_SECRET"
azure_sub_id = "YOUR_SUBSCRIPTION_ID"
azure_tenant_id = "YOUR_TENANT_ID"
azure_vm_ssh_publickey_location = "PATH_TO_PUBLICKEY"
```

2. Execute the shell script [deploy_app.sh](/infrastructure/deploy_app.sh)

This provisions a simple Linux VM using Microsoft Azure, clones the simpleWebApp repository, builds a Docker container and runs the app on this VM, exposing port 80 of the VM to the public (!). The webapp is executed with Gunicorn. The Terraform script currently only provisions one VM, hence not that much requests for the website can be handled. For further improvements and availability of the website, multiple Azure VMs should be used alongside a Load Balancer. Since this project is only for learning reasons, this is not required. This project stores the jokes from the webapp inside of the given MongoDB Cluster under database 'jokes'. For each public IP created with Terraform by executing the script a collection inside of this database is created. The naming scheme of this collection is the public IP without dots (e.g. "127.0.0.1" -> "127001").
> [!CAUTION]
> **Port 22 (for ssh) and Port 80 of the provisioned Azure VM will be exposed to the public!**