#
# Description: Create a Resource Group on Azure
# Dependency: None
#
provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}

# create public IP
resource "azurerm_public_ip" "TSPubIP" {
    name = "TSPubIP"
    location = "${var.location_id}"
    resource_group_name = "${var.csr_resource_group_name}"
    public_ip_address_allocation = "static"
    idle_timeout_in_minutes      = "5"

    tags {
      CreatedDate = "${var.CreatedDate}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create NSG
resource "azurerm_network_security_group" "TSnsg" {
  name                = "TSnsg"
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

resource "azurerm_network_security_rule" "directTSaccess" {
  name                        = "directTSaccess"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  #The following address is Brett's home NAT address
  source_address_prefix       = "108.52.174.105/32"
  destination_address_prefix  = "100.64.1.1/32"
  resource_group_name = "${var.csr_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.TSnsg.name}"
}

resource "azurerm_network_security_rule" "directTSaccess1" {
  name                        = "directTSaccess1"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "171.0.0.0/8"
  destination_address_prefix  = "100.64.1.1/32"
  resource_group_name = "${var.csr_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.TSnsg.name}"
}

resource "azurerm_network_security_rule" "directTSaccess2" {
  name                        = "directTSaccess2"
  priority                    = 103
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "100.64.0.0/16"
  destination_address_prefix  = "100.64.1.1/32"
  resource_group_name = "${var.csr_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.TSnsg.name}"
}

resource "azurerm_network_security_rule" "directLocalUserAccess" {
  name                        = "directLocalUserAccess"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "52.165.223.236/32"
  destination_address_prefix  = "100.64.1.1/32"
  resource_group_name = "${var.csr_resource_group_name}"
  network_security_group_name = "${azurerm_network_security_group.TSnsg.name}"
}


# create network interface
resource "azurerm_network_interface" "TSni" {
    name = "TSni"
    location = "${var.location_id}"
    resource_group_name = "${var.csr_resource_group_name}"
    network_security_group_id = "${azurerm_network_security_group.TSnsg.id}"

    ip_configuration {
        name = "TSipconf"
        subnet_id = "${var.csr_subnet_for_TS}"
        private_ip_address_allocation = "static"
        private_ip_address            = "100.64.1.1"
        public_ip_address_id = "${azurerm_public_ip.TSPubIP.id}"
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
resource "azurerm_virtual_machine" "csrTSvm" {
    name = "csrTSvm01"
    location = "${var.location_id}"
    resource_group_name = "${var.csr_resource_group_name}"
    network_interface_ids = ["${azurerm_network_interface.TSni.id}"]
    vm_size = "Standard_D13_v2"

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2012-R2-Datacenter"
        version = "latest"
    }

    storage_os_disk {
        name = "csrTSvm-osdisk"
        create_option = "FromImage"
    }

    #storage_os_disk {
    #    name          = "bnaTSvm01-osdisk1"
    #    image_uri     = "https://dprtssa.blob.core.windows.net/system/Microsoft.Compute/Images/images/packer-osDisk.e42fb93c-9e91-41b1-80b9-7f7d188a21b8.vhd"
    #    vhd_uri       = "https://dprtssa.blob.core.windows.net/vhds/bnaTSvm01-osdisk.vhd"
    #    os_type       = "windows"
    #    caching       = "ReadWrite"
    #    create_option = "FromImage"
    #  }

    os_profile {
        computer_name = "csrTSvm01"
        admin_username = "csrTSadmin"
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
