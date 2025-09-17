
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6"
    }
  }
  backend "s3" {
    bucket         = "swayatt-backend-state-remote-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "swayatt-backend-state-db"
  }
}

provider "aws" {
  region = "us-east-1"
}


