resource "incus_instance" "ubuntu_instance" {
  count = var.instance_count
  name  = format("%s-%s-%02d", var.name_prefix, terraform.workspace, count.index + 1)
  image = "images:ubuntu/26.04/cloud"
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
