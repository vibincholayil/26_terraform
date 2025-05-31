resource "azurerm_resource_group" "learning_rg" {
  name = var.resource_group_name  
  location = var.location
}

# This Terraform script creates a Virtual Network, Subnet.

resource "azurerm_virtual_network" "vnet_learning" {
  name                = "vnet_learning"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "subnet" {
  name                 = "subnet_learning"
  resource_group_name = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet_learning.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Public IP is created for the Load Balancer.

resource "azurerm_public_ip" "public_ip_learning" {
  name                = "lb_publicip_learning"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "dev"
  }
}

#Load Balancer is created and associated with the public IP.

resource "azurerm_lb" "lb" {
  name                = "lb_learning"
  location            = var.location
  resource_group_name = var.resource_group_name
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip_learning.id
  }
}

# Backend Address Pool is created for the Load Balancer.
resource "azurerm_lb_backend_address_pool" "bepool" {
  loadbalancer_id = azurerm_lb.lb.id  
  name            = "BackEndAddressPool"
}

# Health check

resource "azurerm_lb_probe" "health_probe" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "httpd_probe"
  protocol        = "Tcp"
  port            = 80
  interval_in_seconds = 15
  number_of_probes = 2
}

# Nic

resource "azurerm_network_interface" "nic_learning" {
  name                = "nic-learning-vibin-${count.index + 1}"
  location            = var.location
  resource_group_name = var.resource_group_name
  count = var.vm_count

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Virtual Machines

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "vm-learning-vibin-${count.index + 1}"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = "Standard_B1s"
  admin_username      = var.username
  admin_password      = var.password
  count = var.vm_count
  disable_password_authentication = false
  network_interface_ids = [azurerm_network_interface.nic_learning[count.index].id]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  custom_data = base64encode("#!/bin/bash\nsudo apt-get update\nsudo apt-get install -y nginx\nsudo systemctl start nginx")
}




