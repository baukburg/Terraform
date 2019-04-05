#Create all the VM's as a scale set
resource "azurerm_virtual_machine_scale_set" "BrettDNSvmss" {
  count               = "30"
  name                = "BrettDNSvmss"
  location            = "${var.location_id}"
  resource_group_name = "BrettPrivateDNSRG"
  upgrade_policy_mode = "Manual"
  single_placement_group = false

  sku {
    name     = "Standard_D1_v2"
    tier     = "Standard"
    capacity = "30"
  }

  storage_profile_image_reference {
      publisher = "MicrosoftWindowsServer"
      offer = "WindowsServer"
      sku = "2012-R2-Datacenter"
      version = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun            = 0
    caching        = "ReadWrite"
    create_option  = "Empty"
    disk_size_gb   = 10
  }

  os_profile {
      computer_name_prefix = "DNSvmss"
      admin_username = "BrettAdmin"
      admin_password = "S3cur3P@55w0rd"
  }

  os_profile_windows_config {
      enable_automatic_upgrades = false
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name       = "BrettVMSSIPConf"
      subnet_id  = "${azurerm_subnet.BrettPrivateDNSsubnet.id}"
    }
  }

  tags {
    CreateDate = "${timestamp()}"
    CreatedBy = "${var.CreatedBy}"
    CreatedNB = "${var.CreatedNB}"
    AIT = "${var.AIT}"
    Environment = "${var.Environment}"
  }
}

# create public IP
resource "azurerm_public_ip" "DNSPubIP" {
    name = "DNSPubIP"
    location = "${var.location_id}"
    resource_group_name = "BrettPrivateDNSRG"
    public_ip_address_allocation = "static"
    idle_timeout_in_minutes      = "5"

    tags {
      CreateDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create network interface
resource "azurerm_network_interface" "DNSni" {
    name = "DNSni"
    location = "${var.location_id}"
    resource_group_name = "BrettPrivateDNSRG"

    ip_configuration {
        name = "DNSipconf"
        subnet_id = "${azurerm_subnet.BrettPrivateDNSsubnet.id}"
        private_ip_address_allocation = "dynamic"
        public_ip_address_id = "${azurerm_public_ip.DNSPubIP.id}"
    }

    tags {
      CreatedDate = "${var.CreatedDate}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }
}

# create virtual machine
resource "azurerm_virtual_machine" "BrettDNSTestVM" {
    name = "BrettDNSTestVM"
    location = "${var.location_id}"
    resource_group_name = "BrettPrivateDNSRG"
    network_interface_ids = ["${azurerm_network_interface.DNSni.id}"]
    vm_size = "Standard_D1_v2"

    storage_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2012-R2-Datacenter"
        version = "latest"
    }

    storage_os_disk {
        name = "VM-osdisk"
        create_option = "FromImage"
    }

    os_profile {
        computer_name = "BrettDNSTestVM"
        admin_username = "BrettAdmin"
        admin_password = "S3cur3P@55w0rd"
    }

    os_profile_windows_config {
        enable_automatic_upgrades = false
    }

    tags {
      CreatedDate = "${var.CreatedDate}"
      EditedDate = "${timestamp()}"
      CreatedBy = "${var.CreatedBy}"
      CreatedNB = "${var.CreatedNB}"
      AIT = "${var.AIT}"
      Environment = "${var.Environment}"
    }

}
