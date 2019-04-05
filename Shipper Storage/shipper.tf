# Configure the Microsoft Azure Provider
provider "azurerm" {
  subscription_id = "${var.subscription_id}"
  client_id       = "${var.client_id}"
  client_secret   = "${var.client_secret}"
  tenant_id       = "${var.tenant_id}"
}

# create storage account
resource "azurerm_storage_account" "imageseast70656" {
  name                = "imageseast70656"
  resource_group_name = "csr1000v_rg"
  location            = "${var.location}"
  account_tier        = "Standard"
  account_replication_type = "LRS"

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
resource "azurerm_storage_container" "vhds" {
  name                  = "vhds"
  resource_group_name   = "csr1000v_rg"
  storage_account_name  = "imageseast70656"
  container_access_type = "private"
}
