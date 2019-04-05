variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "created_by" {}
variable "ait" {}
variable "environment" {}

variable "location_id" {
  default = "East US 2"
}

variable "my_resource_group" {
  default = "analyticsRG"
}

variable "my_storage_account" {
  default = "analyticssa"
}

variable "my_storage_container" {
  default = "analyticssc"
}

variable "my_network_security_group" {
  default = "analyticsNSG"
}

variable "admin_username" {
  default = "admin"
}
variable "admin_password" {
  default = "C0mpl3xP@ssw0rd"
}

variable "computer_name" {
  default = "BAtest01"
}
