variable "backend_bucket" {
  description = "The name of the S3 bucket for the Terraform state"
  type        = string
}

variable "backend_key" {
  description = "The path to the Terraform state file inside the S3 bucket"
  type        = string
}

variable "backend_region" {
  description = "The AWS region of the S3 bucket"
  type        = string
}

variable "backend_dynamodb_table" {
  description = "The DynamoDB table for Terraform state locking"
  type        = string
}