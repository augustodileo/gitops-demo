variable "name" {
  description = "Project name"
  type        = string
}

variable "argocd_namespace" {
  description = "Namespace for ArgoCD installation"
  type        = string
}

variable "cluster_resource_whitelist_group" {
  description = "Group for the cluster resources whitelist"
  type        = string
}

variable "cluster_resource_whitelist_kind" {
  description = "Kind for the cluster resources whitelist"
  type        = string
}