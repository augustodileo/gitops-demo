resource "argocd_application" "application" {
  for_each = { for app in var.application : app => app }

  metadata {
    name      = "${each.key}-argocd"
    namespace = "argocd"
  }

  spec {
    project     = var.project

    destination {
      server = "https://kubernetes.default.svc"
      namespace = "argocd"
    }

    source {
      repo_url        = var.repo_url
      path            = "${var.path}/${each.key}"
      target_revision = var.target_revision
    }

    sync_policy {
      automated {
        prune = true
        self_heal = true
      }
    }
  }
}