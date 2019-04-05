variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "created_by" {}
variable "ait" {}
variable "environment" {}

variable "location_id" {
  default = "Central US"
}

variable "my_resource_group" {
  default = "vizimageRG"
}

variable "my_storage_account" {
  default = "vizimagesa"
}

variable "my_storage_container" {
  default = "vizimagesc"
}
