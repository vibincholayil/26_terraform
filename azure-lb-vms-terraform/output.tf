output "resource_group_name" {
  value = azurerm_resource_group.learning_rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet_learning.name
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}

output "public_ip_address" {
  value = azurerm_public_ip.public_ip_learning.ip_address
}

output "load_balancer_name" {
  value = azurerm_lb.lb.name
}

output "load_balancer_frontend_ip_config_name" {
  value = azurerm_lb.lb.frontend_ip_configuration[0].name
}

output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.bepool.id
}

output "health_probe_id" {
  value = azurerm_lb_probe.health_probe.id
}

output "network_interface_ids" {
  value = azurerm_network_interface.nic_learning[*].id
}

output "virtual_machine_ids" {
  value = azurerm_linux_virtual_machine.vm_learning[*].id
}

output "virtual_machine_private_ips" {
  value = [
    for nic in azurerm_network_interface.nic_learning : nic.ip_configuration[0].private_ip_address
  ]
}
