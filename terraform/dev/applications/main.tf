module "argocd" {
  source  = "terraform-module/release/helm"
  version = "2.8.2"

  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"

  app = {
    name             = "argocd"
    version          = "3.27.1"
    chart            = "argo-cd"
    create_namespace = true
    wait             = true
    deploy           = 1
  }

  # No values file provided, defaults will be used
}

data "kubernetes_secret" "argocd_initial_admin_secret" {
  depends_on = [module.argocd]

  metadata {
    name      = "argocd-initial-admin-secret"
    namespace = module.argocd.namespace
  }
}

module "argocd_applications" {
  depends_on = [module.argocd]
  source = "./modules/argocd_application"

  providers = {
    argocd     = argocd
    kubernetes = kubernetes
  }

  application       = var.applications
  repo_url          = var.repo_url
  path              = var.path
  project           = "applications"
  target_revision   = var.target_revision
}