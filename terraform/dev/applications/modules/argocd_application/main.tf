resource "argocd_application" "application" {

  metadata {
    name      = "${var.application}-argocd"
    namespace = var.argocd_namespace
  }

  spec {
    project     = argocd_project.applications.metadata[0].name

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

resource "argocd_project" "applications" {
  metadata {
    name      = var.project
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
      group = "argoproj.io/v1alpha1"
      kind  = "Application"
    }
    orphaned_resources {
      warn = true
    }
  }
}