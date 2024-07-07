terraform {
  required_providers {
    argocd = {
      source = "oboukili/argocd"
      version = "6.1.1"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.4.1"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.7.1"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

provider "argocd" {
  username  = "admin"
  password  = base64decode(data.kubernetes_secret.argocd_initial_admin_secret.data["password"])
  port_forward = true
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }