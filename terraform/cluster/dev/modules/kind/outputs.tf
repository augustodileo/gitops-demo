output "kubeconfig_path" {
  value = local_file.kubeconfig.filename
}

output "kubeconfig_content" {
  value = local_file.kubeconfig.content
}