# resource "incus_image" "alpine-test" {
#   source_image = {
#     remote = "images"
#     name   = "alpine/edge"
#   }
# }
#
# resource "incus_instance" "instance1" {
#   name  = "instance1"
#   image = "images:ubuntu/22.04"
#
#   config = {
#     "boot.autostart" = true
#     "limits.cpu"     = 2
#   }
# }
module "k3s_cluster" {
  source = "./modules/kubernetes_cluster"
}
