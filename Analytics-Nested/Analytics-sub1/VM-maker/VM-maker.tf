# create network interface
resource "azurerm_network_interface" "analyticsNIC" {
    count = "${var.my_count}"
    name = "analyticsNIC-${count.index}"
    location = "${var.location_id}"
    resource_group_name = "${var.my_resource_group}"

    ip_configuration {
        name = "analyticsNICip-${count.index}"
        subnet_id = "${azurerm_subnet.analyticsSN.id}"
        private_ip_address_allocation = "dynamic"
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}

# create virtual machine
resource "azurerm_virtual_machine" "analyticsVM" {
    count = "${var.my_count}"
    name = "${var.computer_name}${format("%03d", count.index)}"
    location = "${var.location_id}"
    resource_group_name = "${var.my_resource_group}"
    network_interface_ids = ["${element(azurerm_network_interface.analyticsNIC.*.id, count.index)}"]
    vm_size = "${var.my_vm_size_01}"

    storage_image_reference {
        publisher = "RedHat"
        offer = "RHEL"
        sku = "7.3"
        version = "latest"
    }

    storage_os_disk {
        name = "osdisk${format("%03d", count.index)}"
        vhd_uri = "${var.vhd_uri_header}/osdisk${format("%03d", count.index)}.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "${var.computer_name}${format("%03d", count.index)}"
        admin_username = "${var.admin_username}${format("%03d", count.index)}"
        admin_password = "${var.admin_password}${format("%03d", count.index)}"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.created_by}"
      AIT = "${var.ait}"
      Environment = "${var.environment}"
    }
}
