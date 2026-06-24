module "k3s_node" {
  source         = "./modules/ubuntu_instance"
  type           = "virtual-machine"
  name_prefix    = "k3s-node"
  instance_count = 3
}

module "lb_node" {
  source         = "./modules/ubuntu_instance"
  type           = "container"
  name_prefix    = "lb-node"
  ram_gib        = 1
  cpu            = 1
  instance_count = 1
}
