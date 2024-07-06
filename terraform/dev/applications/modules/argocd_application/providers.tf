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

provider "argocd" {
  username  = "admin"
  password  = var.argocd_admin_password
  port_forward = true
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}