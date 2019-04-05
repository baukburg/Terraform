# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# Public IP - Create
resource "azurerm_public_ip" "MCGatewayPubIP" {
    name                         = "MCGatewayPubIP"
    location                     = "${var.location_id}"
    resource_group_name          = "csr1000v_rg"
    public_ip_address_allocation = "dynamic"
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

# create subnet
resource "azurerm_subnet" "GatewaySubnet" {
  name                  = "GatewaySubnet"
  resource_group_name   = "csr1000v_rg"
  virtual_network_name  = "csr1000v_vnet1"
  address_prefix        = "100.64.3.0/24"
}
