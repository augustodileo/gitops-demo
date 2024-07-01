terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.64.2"
    }
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