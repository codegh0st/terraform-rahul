
# terraform configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider using profilename
provider "aws" {
  region = "ap-south-1"
  profile = "terraform-profile"
}