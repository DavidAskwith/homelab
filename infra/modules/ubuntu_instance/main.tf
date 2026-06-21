locals {
  image = var.type == "virtual-machine" ? "images:ubuntu/26.04/cloud" : "images:ubuntu/26.04"
  name = var.instance_count > 1 ? format("${var.name_prefix}-%02d", var.instance_count): var.name_prefix
}

resource "incus_instance" "ubuntu_instance" {
  count = var.instance_count
  name  = local.name
  image = local.image
  type  = var.type

  config = {
    "boot.autostart" = true
    "limits.cpu"     = var.cpu
    "limits.memory"  = "${var.ram_gib}GiB"
    "cloud-init.user-data" = file("${path.module}/cloud_init.yaml")
  }

  wait_for {
    type = "cloud-init"
  }
}
