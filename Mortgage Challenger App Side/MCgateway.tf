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
    resource_group_name          = "fd99c6ae-0693-4adb-899b-ea3369ceaee9"
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
  resource_group_name   = "fd99c6ae-0693-4adb-899b-ea3369ceaee9"
  virtual_network_name  = "c925e7d0-d7aa-4d74-b202-e45b5dc991b6"
  address_prefix        = "100.120.16.0/24"
}
