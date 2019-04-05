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

# create a resource group
resource "azurerm_resource_group" "DNS_rg" {
  name     = "DNS_rg"
  location = "${var.location}"

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
resource "azurerm_storage_account" "bnadnsstorage" {
  name                = "bnadnsstorage"
  resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
  location            = "${var.location}"
  account_replication_type = "LRS"
  account_tier        = "Standard"

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
resource "azurerm_storage_container" "DNS_storagecontainer" {
  name                  = "vhd"
  resource_group_name   = "${azurerm_resource_group.DNS_rg.name}"
  storage_account_name  = "${azurerm_storage_account.bnadnsstorage.name}"
  container_access_type = "private"
}

# create public IP
resource "azurerm_public_ip" "DNSPubIP" {
    name = "DNSPubIP"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
    public_ip_address_allocation = "static"
    idle_timeout_in_minutes      = "5"

    tags {
      createddate = "${var.created_date}"
      editeddate = "${timestamp()}"
      createdby = "${var.created_by}"
      creatednb = "${var.created_nb}"
      ait = "${var.ait}"
      environment = "${var.environment}"
    }
}

# create NSG
resource "azurerm_network_security_group" "DNSnsg" {
  name                = "DNSnsg"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.DNS_rg.name}"

  tags {
    CreatedDate = "${var.created_date}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.created_by}"
    CreatedNB = "${var.created_nb}"
    AIT = "${var.ait}"
    Environment = "${var.environment}"
  }
}

resource "azurerm_network_security_rule" "DNSrdpAccess" {
  name                        = "DNSrdpAccess"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  #The following address is Brett's home NAT address
  source_address_prefix       = "108.52.174.105/32"
  destination_address_prefix  = "100.64.1.101/32"
  resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.DNSnsg.name}"
}

resource "azurerm_network_security_rule" "DNSrdpAccess12" {
  name                        = "DNSrdpAccess12"
  priority                    = 112
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "171.0.0.0/8"
  destination_address_prefix  = "100.64.1.101/32"
  resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.DNSnsg.name}"
}

resource "azurerm_network_security_rule" "DNSrdpAccess2" {
  name                        = "DNSrdpAccess2"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  #The following address is Brett's home NAT address
  source_address_prefix       = "108.52.174.105/32"
  destination_address_prefix  = "100.64.2.102/32"
  resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.DNSnsg.name}"
}

resource "azurerm_network_security_rule" "DNSrdpAccess22" {
  name                        = "DNSrdpAccess22"
  priority                    = 122
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "171.0.0.0/8"
  destination_address_prefix  = "100.64.2.102/32"
  resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.DNSnsg.name}"
}

# create a virtual network
resource "azurerm_virtual_network" "dns_vnet" {
  name                = "dnsvnet"
  address_space       = ["100.64.0.0/22"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.DNS_rg.name}"

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
resource "azurerm_subnet" "dnsSubnet" {
  name                 = "dnsSubnet"
  resource_group_name  = "${azurerm_resource_group.DNS_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.dns_vnet.name}"
  address_prefix       = "100.64.1.0/24"
}


# create network interface
resource "azurerm_network_interface" "DNSni" {
    name = "DNSni"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
    network_security_group_id = "${azurerm_network_security_group.DNSnsg.id}"

    #The following line should be edited and uncommented when the Azure DNS servers are known
    #dns_servers = ["8.8.8.8"]

    ip_configuration {
        name = "DNSipconf"
        subnet_id = "${azurerm_subnet.dnsSubnet.id}"
        private_ip_address_allocation = "static"
        private_ip_address            = "100.64.1.101"
        public_ip_address_id = "${azurerm_public_ip.DNSPubIP.id}"
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


# create virtual machine
resource "azurerm_virtual_machine" "DNSvm" {
    name = "DNSvm01"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
    network_interface_ids = ["${azurerm_network_interface.DNSni.id}"]
    vm_size = "Standard_D13_v2"

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2012-R2-Datacenter"
        version = "latest"
    }

    storage_os_disk {
        name = "DNSvm-osdisk"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "DNSvm01"
        admin_username = "DNSadmin"
        admin_password = "S3cur3P@55w0rd"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = false
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

# create subnet
resource "azurerm_subnet" "dnsSubnet2" {
  name                 = "dnsSubnet2"
  resource_group_name  = "${azurerm_resource_group.DNS_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.dns_vnet.name}"
  address_prefix       = "100.64.2.0/24"
}

# create network interface
resource "azurerm_network_interface" "DNSni2" {
    name = "DNSni2"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
    network_security_group_id = "${azurerm_network_security_group.DNSnsg.id}"

    ip_configuration {
        name = "DNSipconf2"
        subnet_id = "${azurerm_subnet.dnsSubnet2.id}"
        private_ip_address_allocation = "static"
        private_ip_address            = "100.64.2.102"
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

# create virtual machine
resource "azurerm_virtual_machine" "DNSvm2" {
    name = "DNSvm02"
    location = "${var.location}"
    resource_group_name = "${azurerm_resource_group.DNS_rg.name}"
    network_interface_ids = ["${azurerm_network_interface.DNSni2.id}"]
    vm_size = "Standard_D13_v2"

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2012-R2-Datacenter"
        version = "latest"
    }

    storage_os_disk {
        name = "DNSvm2-osdisk"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "DNSvm02"
        admin_username = "DNSadmin"
        admin_password = "S3cur3P@55w0rd"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = false
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
