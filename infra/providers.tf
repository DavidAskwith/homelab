terraform {
  required_providers {
    incus = {
      source = "lxc/incus"
    }
  }
}

provider "incus" {
  default_remote = "virt-01"

  remote {
    name    = "virt-01"
  }
}
