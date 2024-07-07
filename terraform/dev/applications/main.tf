module "argocd" {
  source  = "terraform-module/release/helm"
  version = "2.8.2"

  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"

  app = {
    name             = "argocd"
    chart            = "argo-cd"
    version          = "3.27.1" # Specify the version you want to deploy
    create_namespace = true
    wait             = true
  }

  # No values file provided, defaults will be used
}

data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = module.argocd.app["name"]
  }
}

locals {
  argocd_admin_password = base64decode(data.kubernetes_secret.argocd_initial_admin_secret.data["password"])
}

module "argocd_applications" {
  depends_on = [module.argocd]
  source = "./modules/argocd_application"

  provider "argocd" {
    username  = "admin"
    password  = var.argocd_admin_password
    port_forward = true
  }

  provider "kubernetes" {
    config_path = var.kubeconfig_path
  }

  argocd_admin_password = local.argocd_admin_password
  kubeconfig_path   = var.kubeconfig_path

  # Module vars
  application       = var.applications 
  repo_url          = var.repo_url
  path              = var.path
  project           = "applications"
  target_revision   = var.target_revision
}