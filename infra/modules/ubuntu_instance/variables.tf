# All variables are set to min k3s values
variable "type" {
  description = "The type of instance to create (container or virtual-machine)"
  type        = string
  validation {
    condition     = contains(["container", "virtual-machine"], var.type)
    error_message = "The type must be either 'container' or 'virtual-machine'"
  }
}

variable "name_prefix" {
  description = <<EOT
  The prefix for the instance names
  Instance_count and the workspace will be appended to this prefix along with the environment (e.g. '{prefix}-prd-01')"
  EOT
  type        = string
  validation {
    condition     = (
      length(var.name_prefix) >= 1 &&
      length(var.name_prefix) <= 63 &&
      can(regex("^[a-z]", var.name_prefix)) &&
      can(regex("[a-z0-9]$", var.name_prefix)) &&
      can(regex("^[a-z0-9-]+$", var.name_prefix))
    )
    error_message = <<EOT
    Invalid name_prefix "${var.name_prefix}". Rules:
    1. Length between 1 and 63 characters.
    2. Only lowercase letters, numbers, and dashes.
    3. Must start with a lowercase letter.
    4. Must end with a lowercase letter or number.
    EOT
  }
}

variable "instance_count" {
  description = "The number of instances to create"
  type        = number
  default     = 3
}

variable "ram_gib" {
  description = "The amount of RAM to allocated per instance"
  type        = number
  default     = 2
}

variable "cpu" {
  description = "The number of cpu cores per instance"
  type        = number
  default     = 2
}

variable "devices" {
  description = "Device settings for the instance. This is a map of device names to their properties."
  type        = set(object({
    name = string
    type = string
    properties = map(string)
  }))
  default     = null
}
