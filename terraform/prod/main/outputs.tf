output "argocd_initial_admin_password" {
  value     = module.argocd_installation.argocd_initial_admin_password
  sensitive = true
}

output "kubeconfig_content" {
  value     = module.kind.kubeconfig_content
  sensitive = true
}

output "kubeconfig_path" {
  value = module.kind.kubeconfig_path
}