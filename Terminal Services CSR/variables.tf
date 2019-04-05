variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location_id" {
  default = "East US 2"
}

variable "gateway_location" {
  default = "Central US"
}

variable "csr_resource_group_name" {
  default = "csr1000v_rg"
}

variable "csr_subnet_for_TS" {
  default = "/subscriptions/16ab6a0b-41d5-4343-b0d9-e74b627e4679/resourceGroups/csr1000v_rg/providers/Microsoft.Network/virtualNetworks/csr1000v_vnet1/subnets/csr1000v_Subnet2"
}
variable "csr_vnet_ID" {
  default = "/subscriptions/16ab6a0b-41d5-4343-b0d9-e74b627e4679/resourceGroups/csr1000v_rg/providers/Microsoft.Network/virtualNetworks/csr1000v_vnet1"
}
variable "CreatedBy" {}
variable "CreatedNB" {}
variable "CreatedDate" {}
variable "AIT" {}
variable "Environment" {}
