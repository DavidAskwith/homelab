# All variables are set to min k3s values

variable "node_count" {
  description = "The number of nodes in the cluster"
  type        = number
  default     = 3
}

variable "ram_gib" {
  description = "The amount of RAM to allocated each node (in GiB) per node"
  type        = number
  default     = 2
}

variable "cpu" {
  description = "The number of cpu cores per node"
  type        = number
  default     = 2
}

variable "storage" {
  description = "The storage (in GiB) per node"
  type        = number
  default     = 10
}
