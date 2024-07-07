# Provider vars

variable "argocd_admin_password" {
  description = "ArgoCD admin password"
  type        = string
  sensitive   = true
}

variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
}

# Module vars

variable "applications" {
  description = "List of application names"
  type        = list(string)
}

variable "repo_url" {
  description = "Repository URL"
  type        = string
}

variable "path" {
  description = "Path tp the folder"
  type        = string
}

variable "project" {
  description = "ArgoCD project"
  type        = string
}

variable "target_revision" {
  description = "Git target revision"
  type        = string
}