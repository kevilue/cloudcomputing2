# cloudcomputing2
Repository for my project work for the lecture "Cloud Computing II" at the Cooperative State University (DHBW) Stuttgart.

This project uses HashiCorp Terraform and Ansible to create infrastructure with Microsoft Azure as Infrastructure as a Service (IaaS) and deploy a simple Python-WebApp called simpleJokeApp.
> [!WARNING]
> Since IT-Security is not the subject of this lecture, no protection from potential threats and hazards caused by this project is guaranteed.

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

This provisions a simple Linux VM using Microsoft Azure, clones the simpleWebApp repository, builds a Docker container and runs the app on this VM, exposing port 80 of the VM to the public (!). The WebApp is executed with Gunicorn. The Terraform script currently only provisions one VM, hence not that much requests for the website can be handled. For further improvements and availability of the website, multiple Azure VMs should be used alongside a Load Balancer. Since this project is only for learning reasons, this is not required.
> [!CAUTION]
> **Port 22 (for ssh) and Port 80 of the provisioned Azure VM will be exposed to the public!**