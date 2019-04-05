resource "oci_core_instance" "TFInstance1" {
  count = "${var.my_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "TFInstance1${format("%04d", count.index)}"
  image = "${var.InstanceImageOCID[var.region]}"
  shape = "${var.InstanceShape}"

  create_vnic_details {
    subnet_id = "${oci_core_subnet.ExampleSubnet1.id}"
    display_name = "primaryvnic"
    assign_public_ip = true
    hostname_label = "TFInst1${format("%04d", count.index)}"
  },

  metadata {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD7n4mwTT2dKsqt1K4IYmmDesvpka5rgBA6wZDUAE8Oc2ETU52gRAMvPwiOlyyWyMCqooddCD3FwK2EJw8bASbDOyTBJfCeU8srycSv0VpFcl1O2d4yTg4PrWxfylFHt8ZWMYgZpgOXtUS+5CI8O2HaibhtDo0E699YnZgq7WugiHzj5+9sEQL9nIK6z5wNn3bXHJjwhGKJbXIE9CiD1jRxHdB7Mm+Vkd9kzKwJF4KcADSwg6RqE5Xv6K2Tm83h3G+O5td4hgtaHQORKBYifuqiLslpoXLOtNzHFLfe9/aNXvo0bZnt/wln1U9jOwUmLHMS7TJS5H88nC1IRKT2wTk/ linuxkeys"
    user_data = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_instance" "TFInstance2" {
  count = "${var.my_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "TFInstance2${format("%04d", count.index)}"
  image = "${var.InstanceImageOCID[var.region]}"
  shape = "${var.InstanceShape}"

  create_vnic_details {
    subnet_id = "${oci_core_subnet.ExampleSubnet2.id}"
    display_name = "primaryvnic"
    assign_public_ip = true
    hostname_label = "TFInst2${format("%04d", count.index)}"
  },

  metadata {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD7n4mwTT2dKsqt1K4IYmmDesvpka5rgBA6wZDUAE8Oc2ETU52gRAMvPwiOlyyWyMCqooddCD3FwK2EJw8bASbDOyTBJfCeU8srycSv0VpFcl1O2d4yTg4PrWxfylFHt8ZWMYgZpgOXtUS+5CI8O2HaibhtDo0E699YnZgq7WugiHzj5+9sEQL9nIK6z5wNn3bXHJjwhGKJbXIE9CiD1jRxHdB7Mm+Vkd9kzKwJF4KcADSwg6RqE5Xv6K2Tm83h3G+O5td4hgtaHQORKBYifuqiLslpoXLOtNzHFLfe9/aNXvo0bZnt/wln1U9jOwUmLHMS7TJS5H88nC1IRKT2wTk/ linuxkeys"
    user_data = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }
}

resource "oci_core_instance" "TFInstance3" {
  count = "${var.my_count}"
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD + 1],"name")}"
  compartment_id = "${var.compartment_ocid}"
  display_name = "TFInstance3${format("%04d", count.index)}"
  image = "${var.InstanceImageOCID[var.region]}"
  shape = "${var.InstanceShape}"

  create_vnic_details {
    subnet_id = "${oci_core_subnet.ExampleSubnet3.id}"
    display_name = "primaryvnic"
    assign_public_ip = true
    hostname_label = "TFInst3${format("%04d", count.index)}"
  },

  metadata {
    ssh_authorized_keys = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD7n4mwTT2dKsqt1K4IYmmDesvpka5rgBA6wZDUAE8Oc2ETU52gRAMvPwiOlyyWyMCqooddCD3FwK2EJw8bASbDOyTBJfCeU8srycSv0VpFcl1O2d4yTg4PrWxfylFHt8ZWMYgZpgOXtUS+5CI8O2HaibhtDo0E699YnZgq7WugiHzj5+9sEQL9nIK6z5wNn3bXHJjwhGKJbXIE9CiD1jRxHdB7Mm+Vkd9kzKwJF4KcADSwg6RqE5Xv6K2Tm83h3G+O5td4hgtaHQORKBYifuqiLslpoXLOtNzHFLfe9/aNXvo0bZnt/wln1U9jOwUmLHMS7TJS5H88nC1IRKT2wTk/ linuxkeys"
    user_data = "${base64encode(file(var.BootStrapFile))}"
  }

  timeouts {
    create = "60m"
  }
}
