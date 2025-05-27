resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.address_space

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}

resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_prefixes

  depends_on = [azurerm_virtual_network.vnet] # Ensures subnet is created after VNet
}

resource "azurerm_network_interface" "nic" {
  count               = var.vm_count
  name                = "nic-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address            = var.private_ips[count.index]
    private_ip_address_allocation = "Static"
  }

  tags = {
    environment = var.environment
    owner       = var.owner
  }

  lifecycle {
    prevent_destroy = false  # ✅ Allows NIC deletion when destroying VM
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = {
    environment = var.environment
    owner       = var.owner
  }
  
  depends_on = [azurerm_resource_group.rg] # Ensures NSG is created after Resource Group

  lifecycle {
    prevent_destroy = false  # ✅ Ensures NSG can be deleted
  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  count                     = var.vm_count
  network_interface_id      = azurerm_network_interface.nic[count.index].id
  network_security_group_id = azurerm_network_security_group.nsg.id

  depends_on = [azurerm_network_security_group.nsg] # Ensures NSG exists before association
}

resource "azurerm_virtual_machine" "vm" {
  count               = var.vm_count
  name                = "vm-${count.index}"
  location            = var.location
  resource_group_name = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size              = "Standard_DS1_v2"

  depends_on = [azurerm_network_interface_security_group_association.nsg_assoc] # Ensures NIC-NSG association is complete

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  } 

  storage_os_disk {
    name                = "osdisk-${count.index}"
    caching             = "ReadWrite"
    managed_disk_type   = "Standard_LRS"
    create_option       = "FromImage"
  }

  os_profile {
    computer_name  = "vm-${count.index}"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = var.environment
    owner       = var.owner
  }
}