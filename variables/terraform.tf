# terraform configuration
terraform {
  required_version = "~>1.3.0" # terraform version, if empty will download latest version
  required_providers {
    aws = {
      source  = "hashicorp/aws" # repo from where this aws plugin will be downloaded
      version = "~> 5.0" # version of plugin wich will be dowloded when we give terraform init
    }
  }
}

# Configure the AWS Provider using profilename
provider "aws" {
  region = "ap-south-1"
  profile = "terraform-profile"
}