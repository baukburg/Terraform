# create virtual network
resource "azurerm_virtual_network" "analyticsVN" {
    name = "analyticsVN"
    address_space = ["10.1.0.0/16"]
    location = "${var.location_id}"
    resource_group_name = "${var.my_resource_group}"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create subnet
resource "azurerm_subnet" "analyticsSN" {
    name = "analyticsSN"
    resource_group_name = "${var.my_resource_group}"
    virtual_network_name = "${azurerm_virtual_network.analyticsVN.name}"
    address_prefix = "10.1.0.0/22"
}

module "VM-maker" {
  source = "./VM-maker"

  my_count = "${var.my_count}"
  my_vm_size_01 = "${var.my_vm_size_01}"

  dependency_mimic = ["${var.dependency_mimic}"]

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
