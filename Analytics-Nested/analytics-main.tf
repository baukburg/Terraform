# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "arg" {
    name = "${var.my_resource_group}"
    location = "${var.location_id}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create storage account
resource "azurerm_storage_account" "asa" {
    name = "${var.my_storage_account}"
    resource_group_name = "${azurerm_resource_group.arg.name}"
    location = "${var.location_id}"
    account_type = "Standard_LRS"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create storage container
resource "azurerm_storage_container" "asc" {
    name = "${var.my_storage_container}"
    resource_group_name = "${azurerm_resource_group.arg.name}"
    storage_account_name = "${azurerm_storage_account.asa.name}"
    container_access_type = "private"
    depends_on = ["azurerm_storage_account.asa"]
    depends_on = ["azurerm_resource_group"]
}

# create NSG
resource "azurerm_network_security_group" "ansg" {
  name = "${var.my_network_security_group}"
  location = "${var.location_id}"
  resource_group_name = "${azurerm_resource_group.arg.name}"

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
    CreateDate = "${timestamp()}"
    CreatedBy = "${var.created_by}"
    AIT = "${var.ait}"
    Environment = "${var.environment}"
  }
}

module "Analytics-sub1" {
  source = "./Analytics-sub1"

  dependency_mimic = ["${azurerm_resource_group.arg.name}"]

  created_by = "${var.created_by}"
  environment = "${var.environment}"
  location_id = "${var.location_id}"
  computer_name = "${var.computer_name}"
  ait = "${var.ait}"
  admin_username = "${var.admin_username}"
  admin_password = "${var.admin_password}"
  my_resource_group = "${var.my_resource_group}"
  vhd_uri_header = "${azurerm_storage_account.asa.primary_blob_endpoint}${azurerm_storage_container.asc.name}"
}
