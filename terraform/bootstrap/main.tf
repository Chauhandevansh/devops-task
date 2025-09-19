
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}


# backend resources
resource "aws_dynamodb_table" "swayatt_backend_state_table" {
    name = var.state_table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        Name = var.state_table_name
    }
}

resource "aws_s3_bucket" "swayatt_state_bucket" {
    bucket = var.state_bucket_name
    tags = {
        Name = var.state_bucket_name
    }
}