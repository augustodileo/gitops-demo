terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "cluster-creation/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
