module "ubuntu_instance" {
  source         = "./modules/ubuntu_instance"
  type           = "virtual-machine"
  name_prefix    = "k3s-node"
  instance_count = 1
}
