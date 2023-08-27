
# Terraform configuration
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "4.57.0"
    }
  }
}

# Configure the Default AWS Provider
provider "aws" {
  region = "ap-south-1"
  profile = "terraformprofile"
}

# Configure the 2nd AWS Provider, given alias of this provider
provider "aws" {
  region = "ap-southeast-1"
  profile = "terraformprofile"
  alias = "singapore"
}

# Creating ec2 instance using non-default or 2nd AWS Provider
resource "aws_instance" "mytomcatserver" {
  ami = "ami-kjjwlkjsd09lsee0"
  instance_type = "t2.micro"
  provider = aws.singapore # provider with his alias will be used to create this intance.this alisa pointing to singapore region.

  tags = {
    Name = "tomcat-server"
    Environment = "dev"
  }
}

# Note: those resource in which provider is not mentioned, default provider will be used to 
# create the that resource. 
















