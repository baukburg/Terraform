# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "BrettPrivateDNSRG" {
    name = "BrettPrivateDNSRG"
    location = "${var.location_id}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create virtual network
resource "azurerm_virtual_network" "BrettPrivateDNSvnet" {
    name = "BrettPrivateDNSvnet"
    address_space = ["10.0.0.0/16"]
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.BrettPrivateDNSRG.name}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create virtual network
resource "azurerm_virtual_network" "BrettNOTPrivateDNSvnet" {
    name = "BrettNOTPrivateDNSvnet"
    address_space = ["10.1.0.0/16"]
    location = "${var.location_id}"
    resource_group_name = "${azurerm_resource_group.BrettPrivateDNSRG.name}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create subnet
resource "azurerm_subnet" "BrettPrivateDNSsubnet" {
    name = "BrettPrivateDNSsubnet"
    resource_group_name = "${azurerm_resource_group.BrettPrivateDNSRG.name}"
    virtual_network_name = "${azurerm_virtual_network.BrettPrivateDNSvnet.name}"
    address_prefix = "10.0.0.0/20"
}
