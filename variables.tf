variable "nport" {
  description = "Node port"
  type        = number
  #default     = "30201"
}

variable "cpu" {
  description = "CPU limit"
  type        = string
  default     = "0.5"
}

variable "memory" {
  description = "Memory limit"
  type        = string
  default     = "512Mi"
}

variable "user" {
  description = "User"
  type        = string
  default     = "masha"
}

variable "resources" {
  description = "Enter list of allowed resources (pods, nodes, ns,services)"
  type        = list
  default     = ["pods", "nodes", "ns", "services"]
}

variable "verbs" {
  description = "Enter list of allowed verbs (get, create, list, patch, update, watch)"
  type        = list
  default     = ["get", "create", "list"]
}
