# --- root/providers.tf ---

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region                  = "us-west-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = var.aws_profile
}