resource "azurerm_resource_group" "sample_rg" {
  name = "sample-vm-rg"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "example_vnet" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.sample_rg.location
  resource_group_name = azurerm_resource_group.sample_rg.name
}

resource "azurerm_subnet" "example_subnet" {
  name                 = "internal"
  resource_group_name = azurerm_resource_group.sample_rg.name
  virtual_network_name = azurerm_virtual_network.example_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "example_nic" {
  name                = "example-nic"
  location            = azurerm_resource_group.sample_rg.location
  resource_group_name = azurerm_resource_group.sample_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "example_vm" {
  name                = "example-machine"
  location            = azurerm_resource_group.sample_rg.location
  resource_group_name = azurerm_resource_group.sample_rg.name
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.example_nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}