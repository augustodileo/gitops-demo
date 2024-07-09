variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "kubeconfig_path" {
  description = "Optional kubeconfig path"
  type        = string
  default     = ""
}