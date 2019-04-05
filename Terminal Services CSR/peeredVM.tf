
# create a virtual network
resource "azurerm_virtual_network" "peeredvnet" {
  name                = "peeredvnet"
  address_space       = ["10.10.10.0/24"]
  location            = "${var.location_id}"
  resource_group_name = "${var.csr_resource_group_name}"

  tags {
    CreatedDate = "${var.CreatedDate}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.CreatedBy}"
    CreatedNB = "${var.CreatedNB}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

resource "azurerm_virtual_network_peering" "peertoCSR" {
  name                      = "peertoCSR"
  resource_group_name       = "${var.csr_resource_group_name}"
  virtual_network_name      = "${azurerm_virtual_network.peeredvnet.name}"
  remote_virtual_network_id = "${var.csr_vnet_ID}"
  allow_virtual_network_access = "true"
  allow_forwarded_traffic   = "true"
}

resource "azurerm_virtual_network_peering" "peerfromCSR" {
  name                      = "peerfromCSR"
  resource_group_name       = "${var.csr_resource_group_name}"
  virtual_network_name      = "csr1000v_vnet1"
  remote_virtual_network_id = "${azurerm_virtual_network.peeredvnet.id}"
  allow_virtual_network_access = "true"
  allow_forwarded_traffic   = "true"
}

# create subnet
resource "azurerm_subnet" "peeredsubnet1" {
  name                  = "peeredsubnet1"
  resource_group_name   = "${var.csr_resource_group_name}"
  virtual_network_name  = "${azurerm_virtual_network.peeredvnet.name}"
  address_prefix        = "10.10.10.0/24"
}

# create network interface
resource "azurerm_network_interface" "peeredni" {
    name = "peeredni"
    location = "${var.location_id}"
    resource_group_name = "${var.csr_resource_group_name}"

    ip_configuration {
        name = "peeredipconf"
        subnet_id = "${azurerm_subnet.peeredsubnet1.id}"
        private_ip_address_allocation = "static"
        private_ip_address            = "10.10.10.10"
    }

    tags {
      CreatedDate = "${var.CreatedDate}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}


# create virtual machine
resource "azurerm_virtual_machine" "peeredvm" {
    name = "peeredvm"
    location = "${var.location_id}"
    resource_group_name = "${var.csr_resource_group_name}"
    network_interface_ids = ["${azurerm_network_interface.peeredni.id}"]
    vm_size = "Standard_D13_v2"

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2012-R2-Datacenter"
        version = "latest"
    }

    storage_os_disk {
        name = "peeredvm-osdisk"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "peeredvm"
        admin_username = "peeredvmadmin"
        admin_password = "S3cur3P@55w0rd"
    }

    tags {
      CreatedDate = "${var.CreatedDate}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }

}
