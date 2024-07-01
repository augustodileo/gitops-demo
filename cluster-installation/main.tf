module "argocd" {
  source = "./modules/argocd"

  kubeconfig_path = var.kubeconfig_path
}