resource "argocd_project" "this" {
  metadata {
    name      = var.name
    namespace = var.argocd_namespace
  }

  spec {
    description = "Project for managing application deployments"

    source_repos = ["*"]
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = var.argocd_namespace
    }
    cluster_resource_whitelist {
      group = var.cluster_resource_whitelist_group
      kind  = var.cluster_resource_whitelist_kind
    }
    orphaned_resources {
      warn = true
    }
  }
}