# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "rheltest_rg" {
  name     = "rheltest_rg"
  location = "${var.location_id}"

  tags {
    CreatedDate = "${var.created_date}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.created_by}"
    CreatedNB = "${var.created_nb}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

# create public IP
resource "azurerm_public_ip" "rheltestPubIP" {
    name = "rheltestPubIP"
    location = "${var.location_id}"
    resource_group_name =     "${azurerm_resource_group.rheltest_rg.name}"
    public_ip_address_allocation = "static"
    idle_timeout_in_minutes      = "5"

    tags {
      CreatedDate = "${var.created_date}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create a virtual network
resource "azurerm_virtual_network" "rheltestVN" {
  name                = "rheltestVN"
  address_space       = ["10.0.0.0/24"]
  location            = "${var.location_id}"
  resource_group_name =     "${azurerm_resource_group.rheltest_rg.name}"

  tags {
    CreatedDate = "${var.created_date}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.created_by}"
    CreatedNB = "${var.created_nb}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

# create subnet
resource "azurerm_subnet" "rheltestSN" {
  name                 = "rheltestSN"
  resource_group_name =     "${azurerm_resource_group.rheltest_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.rheltestVN.name}"
  address_prefix       = "10.0.0.0/24"
}

# create network interface
resource "azurerm_network_interface" "rheltestni" {
    name = "rheltestni"
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.rheltest_rg.name}"

    ip_configuration {
        name = "rheltestconf"
        subnet_id = "${azurerm_subnet.rheltestSN.id}"
        private_ip_address_allocation = "static"
        private_ip_address            = "10.0.0.10"
        public_ip_address_id = "${azurerm_public_ip.rheltestPubIP.id}"
    }

    tags {
      CreatedDate = "${var.created_date}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create virtual machine
resource "azurerm_virtual_machine" "rheltestVM" {
    name = "rheltest01"
    location = "${var.location_id}"
    resource_group_name =     "${azurerm_resource_group.rheltest_rg.name}"
    network_interface_ids = ["${azurerm_network_interface.rheltestni.id}"]
    vm_size = "Standard_D2_v2"

    #storage_image_reference {
    #    publisher = "RedHat"
    #    offer = "RHEL"
    #    sku = "7.3"
    #    version = "latest"
    #}

    storage_os_disk {
        name = "rheltest01"
        image_uri = "https://saosfactory.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.2c03f43a-7123-4846-acee-6569c7074a7d.vhd"
        vhd_uri = "https://saosfactory.blob.core.windows.net/vhds/rheltest01-osdisk.vhd"
        os_type = "linux"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "rheltest01"
        admin_username = "rheladmin"
        admin_password = "P@55w0rd!@#$"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
      CreatedDate = "${var.created_date}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create second public IP
resource "azurerm_public_ip" "rheltestPubIP2" {
    name = "rheltestPubIP2"
    location = "${var.location_id}"
    resource_group_name =     "${azurerm_resource_group.rheltest_rg.name}"
    public_ip_address_allocation = "static"
    idle_timeout_in_minutes      = "5"

    tags {
      CreatedDate = "${var.created_date}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create second network interface
resource "azurerm_network_interface" "rheltestni2" {
    name = "rheltestni2"
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.rheltest_rg.name}"

    ip_configuration {
        name = "rheltestconf2"
        subnet_id = "${azurerm_subnet.rheltestSN.id}"
        private_ip_address_allocation = "static"
        private_ip_address            = "10.0.0.11"
        public_ip_address_id = "${azurerm_public_ip.rheltestPubIP2.id}"
    }

    tags {
      CreatedDate = "${var.created_date}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create second virtual machine
resource "azurerm_virtual_machine" "rheltestVM2" {
    name = "rheltest02"
    location = "${var.location_id}"
    resource_group_name =     "${azurerm_resource_group.rheltest_rg.name}"
    network_interface_ids = ["${azurerm_network_interface.rheltestni2.id}"]
    vm_size = "Standard_D2_v2"

    #storage_image_reference {
    #    publisher = "RedHat"
    #    offer = "RHEL"
    #    sku = "7.3"
    #    version = "latest"
    #}

    storage_os_disk {
        name = "rheltest02"
        image_uri = "https://saosfactory.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.2c03f43a-7123-4846-acee-6569c7074a7d.vhd"
        vhd_uri = "https://saosfactory.blob.core.windows.net/vhds/rheltest02-osdisk.vhd"
        os_type = "linux"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "rheltest02"
        admin_username = "rheladmin"
        admin_password = "P@55w0rd!@#$"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
      CreatedDate = "${var.created_date}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      CreatedNB = "${var.created_nb}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}
