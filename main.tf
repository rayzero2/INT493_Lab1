provider "azurerm" {
  subscription_id = "aec9d974-66cd-47ff-a449-486fa40a651e"
  client_id       = "3b81259b-e25d-4cd9-b903-d0d4727c5c8d"
  client_secret   = "q4BC8WT2bAq.z4vxKU0S5wr7lbVh_azLEy"
  tenant_id       = "79845616-9df0-43e0-8842-e300feb2642a"
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "INT493test"
  location = "southeastasia"
}

resource "azurerm_virtual_network" "vn" {
  name                = "INT493-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet" "sub493" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vn.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "pi" {
  name                = "INT493test-pip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "ni" {
  name                = "lab1819"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sub493.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pi.id
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = "Lab1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_B1s"

  admin_username      = "azureuser"
  admin_password      = "Azureuser1234"
  disable_password_authentication= false

  network_interface_ids = [
    azurerm_network_interface.ni.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt install nodejs -y",
      "sudo apt-get install npm -y",
      "sudo apt install git -y",
      "git clone https://github.com/rayzero2/INT493_Lab1.git",
      "cd INT493_Lab1/Myweb",
      "npm install",
      "cd ..",
      "sudo mv index.service /lib/systemd/system/index.service",
      "sudo systemctl enable index.service",
      "sudo systemctl start index.service",
    ]

    connection {
      host     = self.public_ip_address
      user     = self.admin_username
      password = self.admin_password
    }
  }
}

