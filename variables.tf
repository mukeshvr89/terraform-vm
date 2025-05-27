variable "vm_count" { type = number }
variable "vnet_name" { type = string }
variable "subnet_name" { type = string }
variable "nsg_name" { type = string }
variable "private_ips" { type = list(string) }
variable "admin_username" { type = string }
variable "admin_password" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "environment" { type = string }
variable "owner" { type = string }
variable "subscription_id" { type = string }
variable "address_space" {
  type = list(string)
  description = "The address space for the virtual network."
}
variable "subnet_prefixes" {
  type = list(string)
  description = "The address prefixes for the subnet."
}