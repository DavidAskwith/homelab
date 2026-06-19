module "k3s_cluster" {
  source = "./modules/kubernetes_cluster"
  node_count = 1
}
