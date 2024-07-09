output "project_name" {
  value = argocd_project.this.metadata[0].name
}