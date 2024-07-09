module "kind" {
  source = "./modules/kind"

  cluster_name = var.cluster_name
  kubeconfig_path = var.kubeconfig_path
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

module "argocd_project" {
  source = "./modules/argocd_project"

  argocd_namespace                  = module.argocd_installation.namespace
  name                              = "applications"
  cluster_resource_whitelist_group  = "argoproj.io/v1alpha1"
  cluster_resource_whitelist_kind   = "Application"
}

module "argocd_application" {
  source = "./modules/argocd_application"

  for_each = { for app in var.applications_list : app => app }

  providers = {
    argocd     = argocd
  }

  application       = each.key
  argocd_namespace  = module.argocd_installation.namespace
  repo_url          = "https://github.com/${var.repo_url}"
  path              = var.path
  project           = module.argocd_project.project_name
  target_revision   = var.target_revision
}

locals {
  kubeconfig_decoded  = yamldecode(module.kind.kubeconfig_content)

  kube_host           = local.kubeconfig_decoded.clusters[0].cluster.server
  kube_ca_cert        = base64decode(local.kubeconfig_decoded.clusters[0].cluster["certificate-authority-data"])
  kube_client_cert    = base64decode(local.kubeconfig_decoded.users[0].user["client-certificate-data"])
  kube_client_key     = base64decode(local.kubeconfig_decoded.users[0].user["client-key-data"])
  kube_token          = lookup(local.kubeconfig_decoded.users[0].user, "token", null)
}