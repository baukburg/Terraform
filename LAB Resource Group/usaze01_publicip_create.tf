#
# Public IP - Create
#
resource "azurerm_public_ip" "ip-lab-vpn" {
    name                         = "ip-lab-vpn"
    location                     = "${var.location_id}"
    resource_group_name          = "${azurerm_resource_group.rg-lab-gateway.name}"
    public_ip_address_allocation = "static"
    idle_timeout_in_minutes      = "5"

    tags {
        CreatedBy    = "${var.CreatedBy}"
        CreatedNB    = "${var.CreatedNB}"
        CreatedDate  = "${timestamp()}"
        AIT          = "${var.AIT}"
        Environment  = "${var.Environment}"
        Persist = "1"
    }
}
