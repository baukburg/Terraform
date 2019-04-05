# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "userstory1" {
    name = "userstory1"
    location = "${var.location_id}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create storage account
resource "azurerm_storage_account" "userstory1storage" {
    name = "userstory1storage"
    resource_group_name = "${azurerm_resource_group.userstory1.name}"
    location = "${var.location_id}"
    account_tier = "Standard"
    account_replication_type = "LRS"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create storage container
resource "azurerm_storage_container" "userstory1storagecontainer" {
    name = "vhd"
    resource_group_name = "${azurerm_resource_group.userstory1.name}"
    storage_account_name = "${azurerm_storage_account.userstory1storage.name}"
    container_access_type = "private"
    depends_on = ["azurerm_storage_account.userstory1storage"]
}

# create virtual network
resource "azurerm_virtual_network" "userstory1vnet" {
    name = "userstory1vnet"
    address_space = ["10.0.0.0/16"]
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.userstory1.name}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create subnet
resource "azurerm_subnet" "userstory1Subnet" {
    name = "userstory1Subnet"
    resource_group_name = "${azurerm_resource_group.userstory1.name}"
    virtual_network_name = "${azurerm_virtual_network.userstory1vnet.name}"
    address_prefix = "10.0.1.0/24"

}

# create NSG
resource "azurerm_network_security_group" "NSG" {
  name = "NSG"
  location = "${var.location_id}"
  resource_group_name = "${azurerm_resource_group.userstory1.name}"

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
    CreatedNB = "${var.created_nb}"
    AIT = "${var.ait}"
    Environment = "${var.environment}"
  }
}

# create network interface
resource "azurerm_network_interface" "userstory1nic" {
    name = "userstory1nic"
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.userstory1.name}"

    ip_configuration {
        name = "userstory1nicIP"
        subnet_id = "${azurerm_subnet.userstory1Subnet.id}"
        private_ip_address_allocation = "dynamic"
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create virtual machine
resource "azurerm_virtual_machine" "userstory1vm" {
    name = "${var.computer_name_01}"
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.userstory1.name}"
    network_interface_ids = ["${azurerm_network_interface.userstory1nic.id}"]
    vm_size = "Standard_A2"

    storage_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "7.3"
        version = "latest"
    }

    storage_os_disk {
        name = "osdisk"
        vhd_uri = "${azurerm_storage_account.userstory1storage.primary_blob_endpoint}${azurerm_storage_container.userstory1storagecontainer.name}/osdisk.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.computer_name_01}"
        admin_username = "${var.admin_username_01}"
        admin_password = "${var.admin_password_01}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

resource "azurerm_public_ip" "brett_test" {
  name = "BrettPublicIp1"
  location = "${var.location_id}"
  resource_group_name = "${azurerm_resource_group.userstory1.name}"
  public_ip_address_allocation = "dynamic"

  tags {
    CreateDate = "${timestamp()}"
    CreatedBy = "${var.created_by}"
    CreatedNB = "${var.created_nb}"
    AIT = "${var.ait}"
    Environment = "${var.environment}"
  }
}
