variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

variable "applications" {
  description = "List of application names"
  type        = list(string)
}

variable "repo_url" {
  description = "Environment of the application"
  type        = string
}

variable "path" {
  description = "Environment of the application"
  type        = string
}

variable "target_revision" {
  description = "Branch or tag for the application manifest"
  type        = string
}