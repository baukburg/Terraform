# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "arg" {
    count = "${ceil(var.my_count / 400)}"
    name = "${var.my_resource_group}${format("%02d", count.index)}"
    location = "${var.location_id}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create storage account
resource "azurerm_storage_account" "asa" {
    count = "${ceil(var.my_count / 400)}"
    name = "${var.my_storage_account}${format("%02d", count.index)}"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"
    location = "${var.location_id}"
    account_type = "Standard_LRS"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create storage container
resource "azurerm_storage_container" "asc" {
    count = "${ceil(var.my_count / 400)}"
    name = "${var.my_storage_container}${format("%02d", count.index)}"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"
    storage_account_name = "${element(azurerm_storage_account.asa.*.name, count.index)}"
    container_access_type = "private"
    depends_on = ["azurerm_storage_account.asa"]
}

# create NSG
resource "azurerm_network_security_group" "ansg" {
  count = "${ceil(var.my_count / 400)}"
  name = "${var.my_network_security_group}${format("%02d", count.index)}"
  location = "${var.location_id}"
  resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"

  security_rule {
    name                       = "HTTP-Allow"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "HTTPS-Allow"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.1.0/24"
  }

  tags {
    CreateDate = "${timestamp()}"
    CreatedBy = "${var.created_by}"
    AIT = "${var.ait}"
    Environment = "${var.environment}"
  }
}

# create virtual network
resource "azurerm_virtual_network" "analyticsVN" {
    name = "analyticsVN"
    address_space = ["10.1.0.0/16"]
    location = "${var.location_id}"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, 0)}"
    depends_on = ["azurerm_storage_account.asa"]

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create subnet
resource "azurerm_subnet" "analyticsSN" {
    name = "analyticsSN"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, 0)}"
    virtual_network_name = "${azurerm_virtual_network.analyticsVN.name}"
    address_prefix = "10.1.0.0/20"
}

# create network interface
resource "azurerm_network_interface" "analyticsNIC" {
    count = "${var.my_count}"
    name = "analyticsNIC${format("%04d", count.index)}"
    location = "${var.location_id}"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"

    ip_configuration {
        name = "analyticsNICip${format("%04d", count.index)}"
        subnet_id = "${azurerm_subnet.analyticsSN.id}"
        private_ip_address_allocation = "dynamic"
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create virtual machine
resource "azurerm_virtual_machine" "analyticsVM" {
    count = "${var.my_count}"
    name = "${var.computer_name}${format("%04d", count.index)}"
    location = "${var.location_id}"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"
    network_interface_ids = ["${element(azurerm_network_interface.analyticsNIC.*.id, count.index)}"]
    vm_size = "Standard_D14_v2"

    storage_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "7.3"
        version = "latest"
    }

    storage_os_disk {
        name = "osdisk${format("%04d", count.index)}"
        vhd_uri = "${element(azurerm_storage_account.asa.*.primary_blob_endpoint, count.index)}${element(azurerm_storage_container.asc.*.name, count.index)}/osdisk${format("%04d", count.index)}.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.computer_name}${format("%04d", count.index)}"
        admin_username = "${var.admin_username}${format("%04d", count.index)}"
        admin_password = "${var.admin_password}${format("%04d", count.index)}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}
