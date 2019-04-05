# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create a resource group
resource "azurerm_resource_group" "vizimagerg" {
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
resource "azurerm_storage_account" "vizimagesa" {
    name = "${var.my_storage_account}"
    resource_group_name = "${azurerm_resource_group.vizimagerg.name}"
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
resource "azurerm_storage_container" "vizimagesc" {
    name = "${var.my_storage_container}${format("%02d", count.index)}"
    resource_group_name = "${azurerm_resource_group.vizimagerg.name}"
    storage_account_name = "${azurerm_storage_account.vizimagesa.name}"
    container_access_type = "private"
}
