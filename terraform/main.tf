resource "azurerm_resource_group" "rg" {
    name = var.rg_name
    location = var.rg_location
}

resource "azurerm_virtual_network" "vnet" {
    name = "terraform-vnet"
    location = var.rg_location
    resource_group_name = azurerm_resource_group.rg.name
    address_space = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet" {
    name = "terraform-subnet"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "publicip" {
    name = "terraform-public-ip"
    location = var.rg_location
    resource_group_name = azurerm_resource_group.rg.name
    allocation_method = "Dynamic"
}

resource "azurerm_network_interface" "nic" {
    name = "terraform-nic"
    location = var.rg_location
    resource_group_name = azurerm_resource_group.rg.name

    ip_configuration {
        name = "terraform-ipconfig"
        subnet_id = azurerm_subnet.subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.publicip.id
    }
}

resource "azurerm_linux_virtual_machine" "vm" {
    name = var.vm_name
    resource_group_name = azurerm_resource_group.rg.name
    location = var.rg_location
    size = "Standard_B1s"
    admin_username = var.admin_username
    network_interface_ids = [azurerm_network_interface.nic.id]

    admin_ssh_key {
        username = var.admin_username
        public_key = var.public_ssh_key
    }

    os_disk {
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Canonical"
        offer = "UbuntuServer"
        sku = "18.04-LTS"
        version = "latest"
    }
}