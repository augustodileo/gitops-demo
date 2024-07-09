output "kubeconfig_content" {
  value     = data.local_file.kubeconfig.content
  sensitive = true
}

output "kubeconfig_path" {
  value = kind_cluster.default.kubeconfig_path
}