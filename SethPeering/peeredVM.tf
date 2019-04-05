provider "azurerm" {
    subscription_id = "${var.subscription_id}"
    client_id       = "${var.client_id}"
    client_secret   = "${var.client_secret}"
    tenant_id       = "${var.tenant_id}"
}

resource "azurerm_virtual_network_peering" "SethVnetToCSR" {
  name                      = "SethVnetToCSR"
  resource_group_name       = "RG_Seth"
  virtual_network_name      = "VNET_Seth_StrongSwan"
  remote_virtual_network_id = "/subscriptions/16ab6a0b-41d5-4343-b0d9-e74b627e4679/resourceGroups/csr1000v_rg/providers/Microsoft.Network/virtualNetworks/csr1000v_vnet1"
  allow_virtual_network_access = "true"
  allow_forwarded_traffic   = "true"
}

resource "azurerm_virtual_network_peering" "CSRToSethVnet" {
  name                      = "CSRToSethVnet"
  resource_group_name       = "${var.csr_resource_group_name}"
  virtual_network_name      = "csr1000v_vnet1"
  remote_virtual_network_id = "/subscriptions/16ab6a0b-41d5-4343-b0d9-e74b627e4679/resourceGroups/RG_Seth/providers/Microsoft.Network/virtualNetworks/VNET_Seth_StrongSwan"
  allow_virtual_network_access = "true"
  allow_forwarded_traffic   = "true"
}
