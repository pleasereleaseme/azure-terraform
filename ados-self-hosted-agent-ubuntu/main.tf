terraform {
  backend "azurerm" {}
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Create a resource group
resource "azurerm_resource_group" "resource_group" {
  name     = "${var.base_name}-${var.environment}-rg"
  location = "${var.resource_group_location}"
  tags     = "${merge(map("CreatedDate", "${substr(timestamp(), 0, 10)}"),var.tags)}"
}

# Create virtual network
resource "azurerm_virtual_network" "virtual_network" {
  name                = "${var.base_name}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.resource_group_location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"
  tags                = "${merge(map("CreatedDate", "${substr(timestamp(), 0, 10)}"),var.tags)}"
}

# Create subnet
resource "azurerm_subnet" "subnet" {
  name                 = "${var.base_name}-subnet"
  resource_group_name  = "${azurerm_resource_group.resource_group.name}"
  virtual_network_name = "${azurerm_virtual_network.virtual_network.name}"
  address_prefix       = "10.0.1.0/24"
}

# Create public IPs
resource "azurerm_public_ip" "public_ip" {
  name                         = "${var.base_name}-public-ip-${count.index}"
  location                     = "${var.resource_group_location}"
  resource_group_name          = "${azurerm_resource_group.resource_group.name}"
  allocation_method            = "Dynamic"
  domain_name_label            = "${var.base_name}-${var.environment}-${count.index}"
  count                        = "${var.node_count}"
  tags                         = "${merge(map("CreatedDate", "${substr(timestamp(), 0, 10)}"),var.tags)}"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "network_security_group" {
  name                = "${var.base_name}-nsg"
  location            = "${var.resource_group_location}"
  resource_group_name = "${azurerm_resource_group.resource_group.name}"

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags     = "${merge(map("CreatedDate", "${substr(timestamp(), 0, 10)}"),var.tags)}"
}

# Create network interface
resource "azurerm_network_interface" "network_interface" {
  name                      = "${var.base_name}-nic-${count.index}"
  location                  = "${var.resource_group_location}"
  resource_group_name       = "${azurerm_resource_group.resource_group.name}"
  network_security_group_id = "${azurerm_network_security_group.network_security_group.id}"
  count                     = "${var.node_count}"
  tags                      = "${merge(map("CreatedDate", "${substr(timestamp(), 0, 10)}"),var.tags)}"

  ip_configuration {
    name                          = "${var.base_name}-ip-config"
    subnet_id                     = "${azurerm_subnet.subnet.id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${azurerm_public_ip.public_ip.*.id[count.index]}"
  }
}

# Create virtual machine
resource "azurerm_virtual_machine" "virtual_machine" {
  name                          = "${var.base_name}-vm-${count.index}"
  location                      = "${var.resource_group_location}"
  resource_group_name           = "${azurerm_resource_group.resource_group.name}"
  network_interface_ids         = ["${azurerm_network_interface.network_interface.*.id[count.index]}"]
  vm_size                       = "${var.vm_size}"
  delete_os_disk_on_termination = true
  count                         = "${var.node_count}"
  tags                          = "${merge(map("CreatedDate", "${substr(timestamp(), 0, 10)}"),var.tags)}"

  storage_os_disk {
    name              = "${var.base_name}-os-disk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "${var.ubuntu_sdk}"
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.base_name}-vm-${count.index}"
    admin_username = "${var.admin_username}"
    custom_data    = "${file("cloud-init.txt")}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${var.ssh_key_data}"
    }
  }
}
