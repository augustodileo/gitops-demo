output "argocd_initial_admin_secret" {
  value = data.kubernetes_secret.argocd_initial_admin_secret.data["password"]
}

output "namespace" {
  value = helm_release.this[0].namespace
}