# Public IP - Create
resource "azurerm_public_ip" "TestGatewaySide1PubIP" {
    name                         = "TestGatewaySide1PubIP"
    location                     = "${var.location_id}"
    resource_group_name          = "${var.csr_resource_group_name}"
    public_ip_address_allocation = "dynamic"
    idle_timeout_in_minutes      = "5"

    tags {
        CreatedBy    = "${var.CreatedBy}"
        CreatedNB    = "${var.CreatedNB}"
        CreatedDate  = "${timestamp()}"
        AIT          = "${var.AIT}"
        Environment  = "${var.Environment}"
    }
}

# Public IP - Create
resource "azurerm_public_ip" "TestGatewaySide2PubIP" {
    name                         = "TestGatewaySide2PubIP"
    location                     = "${var.gateway_location}"
    resource_group_name          = "${var.csr_resource_group_name}"
    public_ip_address_allocation = "dynamic"
    idle_timeout_in_minutes      = "5"

    tags {
        CreatedBy    = "${var.CreatedBy}"
        CreatedNB    = "${var.CreatedNB}"
        CreatedDate  = "${timestamp()}"
        AIT          = "${var.AIT}"
        Environment  = "${var.Environment}"
    }
}

# create a virtual network
resource "azurerm_virtual_network" "gatewayvnet" {
  name                = "gatewayvnet"
  address_space       = ["20.20.20.0/24"]
  location            = "${var.gateway_location}"
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

# create subnet
resource "azurerm_subnet" "gatewaysubnet1" {
  name                  = "gatewaysubnet1"
  resource_group_name   = "${var.csr_resource_group_name}"
  virtual_network_name  = "${azurerm_virtual_network.gatewayvnet.name}"
  address_prefix        = "20.20.20.0/25"
}

# create subnet
resource "azurerm_subnet" "GatewaySubnet" {
  name                  = "GatewaySubnet"
  resource_group_name   = "${var.csr_resource_group_name}"
  virtual_network_name  = "${azurerm_virtual_network.gatewayvnet.name}"
  address_prefix        = "20.20.20.128/25"
}

# create network interface
resource "azurerm_network_interface" "gatewayni" {
    name = "gatewayni"
    location = "${var.gateway_location}"
    resource_group_name = "${var.csr_resource_group_name}"

    ip_configuration {
        name = "gatewayipconf"
        subnet_id = "${azurerm_subnet.gatewaysubnet1.id}"
        private_ip_address_allocation = "static"
        private_ip_address            = "20.20.20.20"
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
resource "azurerm_virtual_machine" "gatewayvm" {
    name = "gatewayvm"
    location = "${var.gateway_location}"
    resource_group_name = "${var.csr_resource_group_name}"
    network_interface_ids = ["${azurerm_network_interface.gatewayni.id}"]
    vm_size = "Standard_D13_v2"

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2012-R2-Datacenter"
        version = "latest"
    }

    storage_os_disk {
        name = "gatewayvm-osdisk"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "gatewayvm"
        admin_username = "gatewayvmadmin"
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
