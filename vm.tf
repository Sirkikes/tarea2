# Creamos una máquina virtual
# https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine

resource "azurerm_virtual_machine" "myVM1" {

    count                 = length(var.vms_name) 
    name                  = "${var.vms_name[count.index]}"
    resource_group_name   = azurerm_resource_group.rg.name
    location              = azurerm_resource_group.rg.location
    vm_size               = "${var.vms_size[count.index]}"
    network_interface_ids = [ azurerm_network_interface.vm_nic[count.index].id ]

    storage_image_reference {
        publisher = "cognosys"
        offer     = "centos-8-stream-free"
        sku       = "centos-8-stream-free"
        version   = "1.2019.0810"
    }

    storage_os_disk {
        name              = "vm_disk${count.index}"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    os_profile {
        computer_name  = "${var.vms_name[count.index]}"
        admin_username = "enrique"
    }

    os_profile_linux_config {
        disable_password_authentication = true
        ssh_keys {
            path = "/home/${var.ssh_user}/.ssh/authorized_keys"
            key_data = file(var.public_key_path)
        }
    }

    plan {
        name      = "centos-8-stream-free"
        product   = "centos-8-stream-free"
        publisher = "cognosys"
    }

    tags = {
        environment = "AZURE-CP2"
    }
}