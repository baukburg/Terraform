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

#
# Resource Group - Create
#
resource "azurerm_resource_group" "rg-lab-gateway" {
    name                    = "rg-lab-gateway"
    location                = "${var.location_id}"

    tags {
        CreatedBy    = "${var.CreatedBy}"
        CreatedNB    = "${var.CreatedNB}"
        CreatedDate  = "${timestamp()}"
        AIT          = "${var.AIT}"
        Environment  = "${var.Environment}"
        Persist = "1"
    }
}
