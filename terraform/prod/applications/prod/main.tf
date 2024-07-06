provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}

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

  values = [templatefile("argocd-values.yml", {
    region                = var.region
    storage               = "4Gi"
  })]

  set_sensitive = [
    {
      path  = "configs.secret.argocd_admin_password"
      value = var.argocd_admin_password
    }
  ]
}

data "kubernetes_secret" "argocd_initial_admin_secret" {
  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = module.release_helm_argocd.namespace
  }
}
