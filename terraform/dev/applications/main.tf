module "argocd_applications" {
  source = "./modules/argocd_application"

  for_each = { for app in var.applications_list : app => app }

  providers = {
    argocd     = argocd
  }

  application       = each.key
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