# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "vizrg" {
    name = "${var.my_resource_group}"
    location = "${var.location_id}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create storage account
resource "azurerm_storage_account" "vizsa" {
    name = "${var.my_storage_account}"
    resource_group_name = "${azurerm_resource_group.vizrg.name}"
    location = "${var.location_id}"
    account_type = "Standard_LRS"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create storage container
resource "azurerm_storage_container" "asc" {
    name = "${var.my_storage_container}"
    resource_group_name = "${azurerm_resource_group.vizrg.name}"
    storage_account_name = "${azurerm_storage_account.vizsa.name}"
    container_access_type = "private"
    depends_on = ["azurerm_storage_account.vizsa"]
}

# create virtual network
resource "azurerm_virtual_network" "vizVN" {
    name = "vizVN"
    address_space = ["10.10.10.0/24"]
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.vizrg.name}"
    depends_on = ["azurerm_storage_account.vizsa"]

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create subnet
resource "azurerm_subnet" "vizSN" {
    name = "vizSN"
    resource_group_name = "${azurerm_resource_group.vizrg.name}"
    virtual_network_name = "${azurerm_virtual_network.vizVN.name}"
    address_prefix = "10.10.10.0/24"
}

# create network interface
resource "azurerm_network_interface" "vizNIC" {
    name = "vizNIC"
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.vizrg.name}"

    ip_configuration {
        name = "vizNICip"
        subnet_id = "${azurerm_subnet.vizSN.id}"
        private_ip_address_allocation = "dynamic"
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create virtual machine
resource "azurerm_virtual_machine" "vizVM" {
    name = "${var.computer_name}"
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.vizrg.name}"
    network_interface_ids = ["${azurerm_network_interface.vizNIC.id}"]
    vm_size = "Standard_D14_v2"

    storage_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "7.3"
        version = "latest"
    }

    storage_os_disk {
        name = "vizvm-osdisk"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.computer_name}"
        admin_username = "${var.admin_username}"
        admin_password = "${var.admin_password}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}
