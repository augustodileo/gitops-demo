terraform {
  required_providers {
    argocd = {
      source = "oboukili/argocd"
      version = "6.1.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}