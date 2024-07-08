variable "application" {
  description = "List of application names"
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace for ArgoCD installation"
  type        = string
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