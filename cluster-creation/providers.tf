terraform {
  required_providers {
    kind = {
      source = "tehcyx/kind"
      version = "0.0.12"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}

provider "kind" {}
provider "local" {}