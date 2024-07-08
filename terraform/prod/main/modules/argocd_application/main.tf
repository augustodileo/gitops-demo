resource "argocd_application" "this" {

  metadata {
    name      = "${var.application}-argocd"
    namespace = var.argocd_namespace
  }

  spec {
    project     = var.project

    destination {
      server = "https://kubernetes.default.svc"
      namespace = var.argocd_namespace
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