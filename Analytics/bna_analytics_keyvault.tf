resource "azurerm_key_vault" "bnavault01" {
  name                = "bnavault01"
  location            = "${var.location_id}"
  resource_group_name = "analyticsRG00"

  sku {
    name = "standard"
  }

  tenant_id = "${var.tenant_id}"

  access_policy {
    tenant_id = "${var.tenant_id}"
    object_id = "${var.client_id}"

    key_permissions = [
      "all",
    ]

    secret_permissions = [
      "get",
    ]
  }

  enabled_for_disk_encryption = true

  tags {
    created_by   = "${var.created_by}"
    created_date = "${timestamp()}"
    ait          = "${var.ait}"
    environment  = "${var.environment}"
  }
}
