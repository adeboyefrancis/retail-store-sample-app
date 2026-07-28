# Terraform Block
terraform {
  required_version = ">= 1.0.0"

  # Remote Backend Block (Bucket, Key, Region, Encryption, Lockfile)
  backend "s3" {
    bucket       = "tfstate-remote-backend-q35e-eu-west-1"
    key          = "devbox/terraform.tfstate"
    region       = "eu-west-1"
    encrypt      = true
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }

    # Random String Generator
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Provider Block
provider "aws" {
  region = var.aws_region
}
