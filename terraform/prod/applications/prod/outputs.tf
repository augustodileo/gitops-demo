output "argocd_admin_password" {
  value     = module.argocd.argocd_initial_admin_password
  sensitive = true
}