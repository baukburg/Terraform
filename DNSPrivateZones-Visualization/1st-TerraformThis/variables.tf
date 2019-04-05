variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "CreatedBy" {}
variable "CreatedNB" {}
variable "CreatedDate" {}
variable "AIT" {}
variable "Environment" {}


variable "location_id" {
  default = "East US 2"
}

variable "my_resource_group" {
  default = "vizRG"
}

variable "my_storage_account" {
  default = "vizsa"
}

variable "my_storage_container" {
  default = "vizsc"
}

variable "admin_username" {
  default = "S3cr3t"
}
variable "admin_password" {
  default = "C0mpl3xP@ssw0rd"
}

variable "computer_name" {
  default = "1l3d9cc8wp3"
}
