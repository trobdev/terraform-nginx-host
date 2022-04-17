# --- root/providers.tf ---

provider "aws" {
  region                   = "us-west-1"
  shared_credentials_files = ["~/.aws/credentials"]
  profile                  = var.aws_profile
}