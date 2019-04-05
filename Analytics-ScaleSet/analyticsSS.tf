# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "arg" {
    count = "${var.set_count}"
    name = "${var.my_resource_group}${format("%02d", count.index)}"
    location = "${var.location_id}"

    tags {
      createddate = "${var.created_date}"
      editeddate = "${timestamp()}"
      createdby = "${var.created_by}"
      creatednb = "${var.created_nb}"
      ait = "${var.ait}"
      environment = "${var.environment}"
    }
}

# create storage account
resource "azurerm_storage_account" "asa" {
    count = "${var.set_count}"
    name = "${var.my_storage_account}${format("%02d", count.index)}"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"
    location = "${var.location_id}"
    account_type = "Standard_LRS"

    tags {
      createddate = "${var.created_date}"
      editeddate = "${timestamp()}"
      createdby = "${var.created_by}"
      creatednb = "${var.created_nb}"
      ait = "${var.ait}"
      environment = "${var.environment}"
    }
}

# create storage container
resource "azurerm_storage_container" "asc" {
    count = "${var.set_count}"
    name = "${var.my_storage_container}${format("%02d", count.index)}"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"
    storage_account_name = "${element(azurerm_storage_account.asa.*.name, count.index)}"
    container_access_type = "private"
    depends_on = ["azurerm_storage_account.asa"]
}

# create NSG
resource "azurerm_network_security_group" "ansg" {
  count = "${var.set_count}"
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
    createddate = "${var.created_date}"
    editeddate = "${timestamp()}"
    createdby = "${var.created_by}"
    creatednb = "${var.created_nb}"
    ait = "${var.ait}"
    environment = "${var.environment}"
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
      createddate = "${var.created_date}"
      editeddate = "${timestamp()}"
      createdby = "${var.created_by}"
      creatednb = "${var.created_nb}"
      ait = "${var.ait}"
      environment = "${var.environment}"
    }
}

# create subnet
resource "azurerm_subnet" "analyticsSN" {
    name = "analyticsSN"
    resource_group_name = "${element(azurerm_resource_group.arg.*.name, 0)}"
    virtual_network_name = "${azurerm_virtual_network.analyticsVN.name}"
    address_prefix = "10.1.0.0/20"
}

#Create all the VM's as a scale set
resource "azurerm_virtual_machine_scale_set" "test" {
  count               = "${var.set_count}"
  name                = "${var.set_name}${format("%02d", count.index)}"
  location            = "${var.location_id}"
  resource_group_name = "${element(azurerm_resource_group.arg.*.name, count.index)}"
  upgrade_policy_mode = "Manual"
  single_placement_group = false

  sku {
    name     = "Standard_D14_v2"
    tier     = "Standard"
    capacity = "${var.my_count}"
  }

  storage_profile_image_reference {
    publisher = "RedHat"
    offer = "RHEL"
    sku = "7.3"
    version = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun            = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }

  os_profile {
    computer_name_prefix  = "${var.computer_name}${count.index}"
    admin_username        = "${var.admin_username}"
    admin_password        = "${var.admin_password}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/myadmin/.ssh/authorized_keys"
      key_data = "${file("~/.ssh/demo_key.pub")}"
    }
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name       = "${var.computer_name}IPConf"
      subnet_id  = "${azurerm_subnet.analyticsSN.id}"
    }
  }

  tags {
    createddate = "${var.created_date}"
    editeddate = "${timestamp()}"
    createdby = "${var.created_by}"
    creatednb = "${var.created_nb}"
    ait = "${var.ait}"
    environment = "${var.environment}"
  }
}
