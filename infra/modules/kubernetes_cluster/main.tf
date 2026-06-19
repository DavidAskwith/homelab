resource "incus_instance" "k3s_node" {
  count = var.node_count
  name  = "k3s-node-0${count.index + 1}"
  image = "images:ubuntu/26.04/cloud"
  type  = "virtual-machine"

  config = {
    "boot.autostart" = true
    "limits.cpu"     = var.cpu
    "limits.memory"  = "${var.ram_gib}GiB"
    "cloud-init.user-data" = file("${path.module}/k3s_node_cloud_init.yaml")
  }

  wait_for {
    type = "cloud-init"
  }
}
