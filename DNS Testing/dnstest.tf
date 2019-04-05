resource "azurerm_dns_zone" "bnadnstest" {
  name                = "bnadnstest.com"
  resource_group_name = "${var.dns_resource_group_name}"
}

resource "azurerm_dns_a_record" "test01" {
  name                = "test01"
  zone_name           = "${azurerm_dns_zone.bnadnstest.name}"
  resource_group_name = "${var.dns_resource_group_name}"
  ttl                 = 300
  records             = ["10.0.1.1"]
}

resource "azurerm_dns_ptr_record" "test01" {
  name                = "test01"
  zone_name           = "${azurerm_dns_zone.bnadnstest.name}"
  resource_group_name = "${var.dns_resource_group_name}"
  ttl                 = 300
  records             = ["bnadnstest.com"]
}

resource "azurerm_dns_a_record" "test02" {
  name                = "test02"
  zone_name           = "${azurerm_dns_zone.bnadnstest.name}"
  resource_group_name = "${var.dns_resource_group_name}"
  ttl                 = 300
  records             = ["10.0.1.2"]
}

resource "azurerm_dns_ptr_record" "test02" {
  name                = "test02"
  zone_name           = "${azurerm_dns_zone.bnadnstest.name}"
  resource_group_name = "${var.dns_resource_group_name}"
  ttl                 = 300
  records             = ["bnadnstest.com"]
}
