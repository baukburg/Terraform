# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "csr1000v_rg" {
  name     = "${var.csr1000v_rgName}"
  location = "${var.location}"

  tags {
    CreatedDate = "${var.CreatedDate}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.CreatedBy}"
    CreatedNB = "${var.CreatedNB}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

# create storage account
resource "azurerm_storage_account" "csr1000v_storage" {
  name                = "${var.csr1000v_storageName}"
  resource_group_name = "${azurerm_resource_group.csr1000v_rg.name}"
  location            = "${var.location}"
  account_type        = "${var.storagetype}"

  tags {
    CreatedDate = "${var.CreatedDate}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.CreatedBy}"
    CreatedNB = "${var.CreatedNB}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

# create storage container
resource "azurerm_storage_container" "csr1000v_storagecontainer" {
  name                  = "vhd"
  resource_group_name   = "${azurerm_resource_group.csr1000v_rg.name}"
  storage_account_name  = "${azurerm_storage_account.csr1000v_storage.name}"
  container_access_type = "private"
}


# create NSG
resource "azurerm_network_security_group" "csr1000v_NSG" {
  name                = "${var.csr1000v_NSGname}"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.csr1000v_rg.name}"

  tags {
    CreatedDate = "${var.CreatedDate}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.CreatedBy}"
    CreatedNB = "${var.CreatedNB}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

resource "azurerm_network_security_rule" "VPNNAT" {
  name                        = "VPNNAT"
  priority                    = 101
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "171.159.0.0/16"
  destination_address_prefix  = "13.68.94.87/32"
  resource_group_name         = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.csr1000v_NSG.name}"
}

resource "azurerm_network_security_rule" "VPNOUT" {
  name                        = "VPNOUT"
  priority                    = 104
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "171.159.0.0/16"
  resource_group_name         = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.csr1000v_NSG.name}"
}

resource "azurerm_network_security_rule" "tempinternetallow" {
  name                        = "temp-allow-internet-Rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "171.159.0.0/16"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.csr1000v_NSG.name}"
}

resource "azurerm_network_security_rule" "tempbrettallow" {
  name                        = "temp-allow-brett-Rule"
  priority                    = 102
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "108.52.174.105/32"
  destination_address_prefix  = "*"
  resource_group_name         = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.csr1000v_NSG.name}"
}

resource "azurerm_network_security_rule" "VPNNAT2" {
  name                        = "VPNNAT2"
  priority                    = 105
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "171.155.0.0/16"
  destination_address_prefix  = "13.68.94.87/32"
  resource_group_name         = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.csr1000v_NSG.name}"
}

resource "azurerm_network_security_rule" "VPNOUT2" {
  name                        = "VPNOUT2"
  priority                    = 106
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "171.155.0.0/16"
  resource_group_name         = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.csr1000v_NSG.name}"
}

resource "azurerm_network_security_rule" "VPNOUT3" {
  name                        = "VPNOUT3"
  priority                    = 120
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "8.8.8.8/32"
  resource_group_name         = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_name = "${azurerm_network_security_group.csr1000v_NSG.name}"
}

# create a virtual network
resource "azurerm_virtual_network" "csr1000v_vnet1" {
  name                = "${var.csr1000v_vnetname1}"
  address_space       = ["${var.vnet1addressspace}"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.csr1000v_rg.name}"

  tags {
    CreatedDate = "${var.CreatedDate}"
    EditedDate = "${timestamp()}"
    CreatedBy = "${var.CreatedBy}"
    CreatedNB = "${var.CreatedNB}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

# create subnet
resource "azurerm_subnet" "csr1000v_Subnet1" {
  name                 = "${var.csr1000v_Subnet1name}"
  resource_group_name  = "${azurerm_resource_group.csr1000v_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.csr1000v_vnet1.name}"
  address_prefix       = "${var.csr1000v_Subnet1prefix}"
}

# create subnet
resource "azurerm_subnet" "csr1000v_Subnet2" {
  name                 = "${var.csr1000v_Subnet2name}"
  resource_group_name  = "${azurerm_resource_group.csr1000v_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.csr1000v_vnet1.name}"
  address_prefix       = "${var.csr1000v_Subnet2prefix}"
  route_table_id       = "${azurerm_route_table.routetable.id}"
}

# create subnet
resource "azurerm_subnet" "csrGatewaySubnet" {
  name                 = "${var.GatewaySubnetName}"
  resource_group_name  = "${azurerm_resource_group.csr1000v_rg.name}"
  virtual_network_name = "${azurerm_virtual_network.csr1000v_vnet1.name}"
  address_prefix       = "${var.GatewaySubnetPrefix}"
}

# create network interface
resource "azurerm_network_interface" "csr1000v_nic1" {
  name                      = "${var.csr1000v_nic1name}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.csr1000v_NSG.id}"

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.csr1000v_NIC1Address}"
    subnet_id                     = "${azurerm_subnet.csr1000v_Subnet1.id}"
    public_ip_address_id          = "/subscriptions/16ab6a0b-41d5-4343-b0d9-e74b627e4679/resourceGroups/rg-lab-gateway/providers/Microsoft.Network/publicIPAddresses/ip-lab-vpn"
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

# create network interface
resource "azurerm_network_interface" "csr1000v_nic2" {
  name                      = "${var.csr1000v_nic2name}"
  location                  = "${var.location}"
  resource_group_name       = "${azurerm_resource_group.csr1000v_rg.name}"
  network_security_group_id = "${azurerm_network_security_group.csr1000v_NSG.id}"
  enable_ip_forwarding      = true

  ip_configuration {
    name                          = "ipconfig1"
    private_ip_address_allocation = "static"
    private_ip_address            = "${var.csr1000v_NIC2Address}"
    subnet_id                     = "${azurerm_subnet.csr1000v_Subnet2.id}"
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

# create a route table
resource "azurerm_route_table" "routetable" {
  name                = "routetable"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.csr1000v_rg.name}"

  route {
    name           = "Target-Subnet1-To-CSR"
    address_prefix =  "${var.csr1000v_Subnet1prefix}"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${var.csr1000v_NIC2Address}"
  }

  route {
    name           = "Target-Bank-To-CSR"
    address_prefix =  "${var.bank_SubnetPrefix}"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${var.csr1000v_NIC2Address}"
  }

  route {
    name           = "Target-Bank2-To-CSR"
    address_prefix =  "${var.bank_Subnet2Prefix}"
    next_hop_type  = "VirtualAppliance"
    next_hop_in_ip_address = "${var.csr1000v_NIC2Address}"
  }
}

# create virtual machine
resource "azurerm_virtual_machine" "csr1000v_vm" {
  name                         = "${var.csr1000v_vmname}"
  location                     = "${var.location}"
  resource_group_name          = "${azurerm_resource_group.csr1000v_rg.name}"
  network_interface_ids        = ["${azurerm_network_interface.csr1000v_nic1.id}", "${azurerm_network_interface.csr1000v_nic2.id}"]
  primary_network_interface_id = "${azurerm_network_interface.csr1000v_nic1.id}"
  vm_size                      = "${var.csr1000v_vmsize}"

  plan {
    "name"      = "csr-azure-byol"
    "publisher" = "cisco"
    "product"   = "cisco-csr-1000v"
  }

  os_profile {
    computer_name  = "testuser"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }

  storage_image_reference {
    publisher = "cisco"
    offer     = "cisco-csr-1000v"
    sku       = "csr-azure-byol"
    version   = "latest"
  }

  storage_os_disk {
    name          = "csr-osdisk"
    vhd_uri       = "${azurerm_storage_account.csr1000v_storage.primary_blob_endpoint}${azurerm_storage_container.csr1000v_storagecontainer.name}/csr-osdisk.vhd"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.csr1000v_storage.primary_blob_endpoint}"
  }

  connection {
    host     = "13.68.94.87"
    type     = "ssh"
    user     = "${var.admin_username}"
    password = "${var.admin_password}"
    timeout  = "10m"
    agent = false
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
