variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "csr1000v_rgName" {
  description = "Resource Group for CSR 1000v"
  default     = "csr1000v_rg"
}

variable "location" {
  description = "Resource location"
  default     = "East US 2"
}

variable "csr1000v_storageName" {
  description = "Storage Account Name"
  default     = "csr1000v2nicstorage"
}

variable "storagetype" {
  description = "Stroage Account Type"
  default     = "Standard_LRS"
}

variable "csr1000v_publicipname" {
  description = "Public IP Address Name"
  default     = "csrpip"
}

variable "publicipdns" {
  description = "Domain name lable"
  default     = "csr1000v"
}

variable "csr1000v_NSGname" {
  description = "Network Security Group Name"
  default     = "csr1000v_NSG"
}

variable "termserver_NSGname" {
  description = "Network Security Group Name"
  default     = "Termserver_NSG"
}

variable "csr1000v_vnetname1" {
  description = "VNet Name 1"
  default     = "csr1000v_vnet1"
}

variable "vnet1addressspace" {
  description = "VNet address"
  default     = "100.64.0.0/22"
}

variable "csr1000v_Subnet1name" {
  description = "CSR Subnet 01"
  default     = "csr1000v_Subnet1"
}

variable "csr1000v_Subnet2name" {
  description = "CSR Subnet 02"
  default     = "csr1000v_Subnet2"
}

variable "GatewaySubnetName" {
  description = "Name of Subnet for Hosting Azure Gateways"
  default     = "GatewaySubnet"
}

variable "GatewaySubnetPrefix" {
  description = "Gateway CIDR address"
  default     = "100.64.3.0/24"
}

variable "csr1000v_Subnet1prefix" {
  description = "Subnet1 address"
  default     = "100.64.2.0/24"
}

variable "csr1000v_Subnet2prefix" {
  description = "Subnet1 address"
  default     = "100.64.0.0/23"
}

variable "bank_SubnetPrefix" {
  description = "Subnet of bank devices communicating to Azure"
  default     = "171.155.176.0/24"
}

variable "bank_Subnet2Prefix" {
  description = "Subnet of bank devices communicating to Azure"
  default     = "171.159.222.0/24"
}

variable "csr1000v_NIC1Address" {
  description = "address for first CSR nic"
  default     = "100.64.2.5"
}

variable "csr1000v_NIC2Address" {
  description = "address for second CSR nic"
  default     = "100.64.1.10"
}

variable "csr1000v_nic1name" {
  description = "CSR Nic 1"
  default     = "csr1000v_nic1"
}

variable "csr1000v_nic2name" {
  description = "CSR Nic 2"
  default     = "csr1000v_nic2"
}

variable "csr1000v_vmname" {
  description = "VM Name"
  default     = "82ec4020-fcb9-4025-aa6b-3ce165ddc9b9"
}

variable "csr1000v_vmsize" {
  description = "VM Instance Size"
  default     = "Standard_D2_v2"
}

variable "admin_username" {
  default = "csradmin"
}

variable "admin_password" {
  default = "P@55w0rd!@#$"
}

variable "CreatedBy" {}
variable "CreatedNB" {}
variable "CreatedDate" {}
variable "AIT" {}
variable "Environment" {}
