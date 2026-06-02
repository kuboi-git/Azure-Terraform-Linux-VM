provider "azurerm" {
    features {}
}

resource "azurerm_resource_group" "rg" {
    name     = "rg-terraform-test"
    location = "japaneast"
}

resource "azurerm_virtual_network" "vnet" {
    name                = "vnet-terraform-test"
    address_space       = ["10.0.0.0/16"]
    location            = "japaneast"
    resource_group_name = azurerm_resource_group.rg.name 
}

resource "azurerm_subnet" "subnet" {
    name                 = "subnet-terraform-test"
    resource_group_name  = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes     = ["10.0.10.0/24"] 
}

resource "azurerm_network_security_group" "nsg" {
    name                = "nsg-terraform-test"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
}

resource "azurerm_subnet_network_security_group_association" "nsg-association" {
    subnet_id                 = azurerm_subnet.subnet.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_public_ip" "pip" {
    name                = "pip-terraform-test"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method   = "Static"
}

resource "azurerm_network_interface" "nic" {
    name                = "nic-terraform-test"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "internal"
        subnet_id                     = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.pip.id        
    }    
}

resource "azurerm_linux_virtual_machine" "vm" {
    name                = "vm-terraform-test"
    resource_group_name = azurerm_resource_group.rg.name
    location            = azurerm_resource_group.rg.location
    size                = "Standard_D2s_v3"
    admin_username      = "azureuser"

    network_interface_ids = [
        azurerm_network_interface.nic.id,
    ]

    disable_password_authentication = true

    admin_ssh_key {
        username = "azureuser"
        public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKp2Fy0oy2/rJlfj+mnHQsBz4prP5xvSk7f92Y9+N6p0 kuboi@LAPTOP-89Q1ELTG"
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "0001-com-ubuntu-server-jammy"
        sku = "22_04-lts"
        version = "latest"
    }

}

resource "azurerm_network_security_rule" "ssh" {
    name                        = "allow-ssh"
    priority                    = 1001
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "22"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
}

resource "azurerm_network_security_rule" "http" {
    name                        = "allow-http"
    priority                    = 1002
    direction                   = "Inbound"
    access                      = "Allow"
    protocol                    = "Tcp"
    source_port_range           = "*"
    destination_port_range      = "80"
    source_address_prefix       = "*"
    destination_address_prefix  = "*"
    resource_group_name         = azurerm_resource_group.rg.name
    network_security_group_name = azurerm_network_security_group.nsg.name
}
