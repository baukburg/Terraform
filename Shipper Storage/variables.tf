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

variable "CreatedBy" {}
variable "CreatedNB" {}
variable "CreatedDate" {}
variable "AIT" {}
variable "Environment" {}
