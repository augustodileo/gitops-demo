locals {
  kubeconfig_path_expanded = var.kubeconfig_path != "" ? var.kubeconfig_path : abspath("${path.root}/kubeconfig-${var.cluster_name}.yaml")
}

data "local_file" "kubeconfig" {
  filename = kind_cluster.default.kubeconfig_path
}

resource "kind_cluster" "default" {
  name            = var.cluster_name
  wait_for_ready  = true
  kubeconfig_path = local.kubeconfig_path_expanded

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.23.4"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.23.4"
    }

    node {
      role = "worker"
      image = "kindest/node:v1.23.4"
    }
  }
}