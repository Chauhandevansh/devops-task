
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6"
    }
  }
  required_version = ">= 1.3.0"
  backend "s3" {
    bucket         = "swayatt-backend-state-remote-bucket"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "swayatt-backend-state-db"
  }
}

provider "aws" {
  region = "us-east-1"
}


