resource "argocd_application" "applications" {
  metadata {
    name      = "${var.application}-argocd"
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
      path            = "${var.path}/${var.application}"
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