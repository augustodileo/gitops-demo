# INPUTS KIND module
variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
}

variable "kubeconfig_path" {
  description = "Optional kubeconfig path"
  type        = string
  default     = ""
}

# INPUTS ARGOCD_APPLICATION module
variable "applications_list" {
  description = "List of application names"
  type        = list(string)
}

variable "path" {
  description = "Path of the applications folder"
  type        = string
}

variable "repo_url" {
  description = "Environment of the application"
  type        = string
}

variable "target_revision" {
  description = "Branch or tag for the application manifest"
  type        = string
}