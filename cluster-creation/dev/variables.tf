variable "cluster_name" {
  description = "Name of the Kubernetes cluster"
  type        = string
  default     = "dev-cluster" # or "prod-cluster" for production
}