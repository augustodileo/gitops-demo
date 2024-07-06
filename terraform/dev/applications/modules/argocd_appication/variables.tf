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

variable "application" {
  description = "Application name"
  type        = string
}

variable "repo_url" {
  description = "Repository URL"
  type        = string
}

variable "path" {
  description = "Path in the repository"
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