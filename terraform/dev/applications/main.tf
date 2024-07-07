module "argocd_applications" {
  source = "./modules/argocd_application"

  providers = {
    argocd     = argocd
  }

  application       = var.applications
  argocd_namespace  = module.argocd_installation.namespace
  repo_url          = "https://github.com/${var.repo_url}"
  path              = var.path
  project           = "applications"
  target_revision   = var.target_revision
}

module "argocd_installation" {
  source = "./modules/argocd_installation"

  providers = {
    kubernetes      = kubernetes
    helm            = helm
  }

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
}