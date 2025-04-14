# Microsoft Azure resource configuration

# Create resource group
resource "azurerm_resource_group" "rg" {
  name     = "SimpleJokeAppRG"
  location = "westeurope"
}

# Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "jokeAppVNet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "jokeAppSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create public IP
resource "azurerm_public_ip" "public_ip" {
  name                = "jokeAppPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "jokeAppNIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "jokeAppNicConfig"
    subnet_id                     = azurerm_subnet.subnet.id
    public_ip_address_id          = azurerm_public_ip.public_ip.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Security group with rules for exposing ports
resource "azurerm_network_security_group" "nsg" {
  name                = "jokeAppNSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
    
    security_rule {
      name                        = "allow_flask"
      priority                    = 110
      direction                   = "Inbound"
      access                      = "Allow"
      protocol                    = "Tcp"
      source_port_range           = "*"
      destination_port_range      = "80"
      source_address_prefix       = "*"
      destination_address_prefix  = "*"
    }

    security_rule {
      name                    = "open_ssh"
      priority                = 100
      direction               = "Inbound"
      access                  = "Allow"
      protocol                = "Tcp"
      source_port_range       = "*"
      destination_port_range  = "22"
      source_address_prefix   = "*"
      destination_address_prefix = "*"
    }
}

# Associate the network interface with the network security group
resource "azurerm_network_interface_security_group_association" "nsg_association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}


# Create Linux virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                = "joke-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_DS1_v2"
  admin_username      = "azureuser"
  network_interface_ids = [azurerm_network_interface.nic.id]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(var.ssh_publickey_location)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }


}