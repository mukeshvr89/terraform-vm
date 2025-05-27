output "vm_private_ips" {
  value = [for nic in azurerm_network_interface.nic : nic.ip_configuration[0].private_ip_address]
}