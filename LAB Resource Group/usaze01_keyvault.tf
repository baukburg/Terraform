resource "azurerm_key_vault" "labvault01" {
  name                = "labvault01"
  location            = "${var.location_id}"
  resource_group_name = "rg-lab-gateway"

  sku {
    name = "standard"
  }

  tenant_id = "9cf3a027-8e33-4b04-84fe-de2839487053"

  access_policy {
    tenant_id = "9cf3a027-8e33-4b04-84fe-de2839487053"
    object_id = "476cf92e-c177-47ad-b8a9-f3dc63c75d00"

    key_permissions = [
      "create",
    ]

    secret_permissions = [
      "get",
    ]
  }

  enabled_for_disk_encryption = true

  tags {
    CreatedBy    = "${var.CreatedBy}"
    CreatedNB    = "${var.CreatedNB}"
    CreatedDate  = "${timestamp()}"
    AIT          = "${var.AIT}"
    Environment  = "${var.Environment}"
  }
}
