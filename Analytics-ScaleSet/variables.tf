variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "created_by" {}
variable "created_nb" {}
variable "created_date" {}
variable "ait" {}
variable "environment" {}

variable "my_count" {}
variable "set_count" {}

variable "location_id" {
  default = "West US"
}

variable "my_resource_group" {
  default = "bctestRG"
}

variable "my_storage_account" {
  default = "bctestsa"
}

variable "my_storage_container" {
  default = "bctestsc"
}

variable "my_network_security_group" {
  default = "bctestNSG"
}

variable "admin_username" {
  default = "myadmin"
}
variable "admin_password" {
  default = "C0mpl3xP@ssw0rd"
}

variable "computer_name" {
  default = "bctest20"
}

variable "set_name" {
  default = "bctestSet"
}
