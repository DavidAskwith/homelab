module "k3s_node" {
  source         = "./modules/ubuntu_instance"
  type           = "virtual-machine"
  name_prefix    = "k3s-node"
  instance_count = 3
}

resource "incus_network" "external" {
  name        = "external0"
  description = "External Access Network"
  type        = "physical"
  config = {
    "parent" = "eno1"
  }
}

module "lb_node" {
  source      = "./modules/ubuntu_instance"
  type        = "container"
  name_prefix = "lb-node"
  ram_gib     = 1
  cpu         = 1
  devices = [{
    name = "eth0"
    type = "nic"

    properties = {
      network = "${incus_network.external.name}"
    }
  }]
  instance_count = 1
}
