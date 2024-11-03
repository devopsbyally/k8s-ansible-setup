# Terraform block
terraform {
  required_version = "~> 1.5"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
# Provider block

provider "aws" {
  region = var.aws_region
}