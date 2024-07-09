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
    kind = {
      source = "tehcyx/kind"
      version = "0.0.12"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = "2.7.1"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path = module.kind.kubeconfig_path
  }
}

provider "argocd" {
  username  = "admin"
  password  = module.argocd_installation.argocd_initial_admin_password
  port_forward = true

  kubernetes {
    host = local.kube_host
    cluster_ca_certificate = local.kube_ca_cert
    client_certificate = local.kube_client_cert
    client_key = local.kube_client_key
    token = local.kube_token
  }
}

provider "kubernetes" {
  config_path = module.kind.kubeconfig_path
}

provider "kind" {}
provider "local" {}