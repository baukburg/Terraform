variable "created_by" {}
variable "ait" {}
variable "environment" {}

variable "admin_username" {}
variable "admin_password" {}
variable "location_id" {}
variable "computer_name" {}

variable "my_resource_group" {}
variable "vhd_uri_header" {}

variable "dependency_mimic" {}

variable "my_count" {
  default = 20
}

variable "my_vm_size_01" {
  default = "Standard_D2"
}
