terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.57.0"
    }
  }
}

provider "aws" {
  profile = "terraformProfile" # this profile is set aws configure <profilename>, holds aws login creds access-key and secret-key
  region = "ap-south-1" # this is default region 
}