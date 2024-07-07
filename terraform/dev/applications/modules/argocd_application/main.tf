resource "argocd_application" "application" {
  depends_on = [argocd_project.applications]

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

resource "argocd_project" "applications" {
  metadata {
    name      = var.project
    namespace = "argocd"
  }

  spec {
    description = "Project for managing application deployments"

    source_repos = ["*"]
    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
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