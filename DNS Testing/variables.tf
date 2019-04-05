variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

variable "location" {
  description = "Resource location"
  default     = "Central US"
}

variable "dns_resource_group_name" {
  default = "dns_rg"
}

variable "created_by" {}
variable "created_nb" {}
variable "created_date" {}
variable "ait" {}
variable "environment" {}
