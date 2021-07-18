# Creación de red
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_network

resource "azurerm_virtual_network" "vm_net" {
    name                = "kubenet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    tags = {
        environment = "AZURE-CP2"
    }
}

# Creación de subnet
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet

resource "azurerm_subnet" "vm_subnet" {
    name                   = "kubesubnet"
    resource_group_name    = azurerm_resource_group.rg.name
    virtual_network_name   = azurerm_virtual_network.vm_net.name
    address_prefixes       = ["10.0.2.0/24"]

}

# Create NIC
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface

resource "azurerm_network_interface" "vm_nic" {
  count               = length(var.vms_name) 
  name                = "kube_nic_${var.vms_name[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                           = "kube_ipconf_${var.vms_name[count.index]}"
    subnet_id                      = azurerm_subnet.vm_subnet.id 
    private_ip_address_allocation  = "Static"
    private_ip_address             = "10.0.2.${count.index + 20}"
    public_ip_address_id           = azurerm_public_ip.vm_publicip[count.index].id
  }

  tags = {
    environment = "AZURE-CP2"
  }

}

# IP pública
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip

resource "azurerm_public_ip" "vm_publicip" {
  count               = length(var.vms_name) 
  name                = "kube_pip_${var.vms_name[count.index]}"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Static"
  sku                 = "Basic"

  tags = {
    environment = "AZURE-CP2"
  }

}