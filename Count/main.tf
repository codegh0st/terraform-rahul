terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # random provider to randomize the string and number 
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
  }
}



# Declaring env var Access Key
variable "AK" {
  type = string
  description = "tis is example input variable which we set using export cmd in terminal"
}

# Declaring evn var Secret Key
variable "SK" {
  type = string
  description = "tis is example input variable which we set using export cmd in terminal"
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
  access_key = var.AK
  secret_key = var.SK
}

# Create EC2 intatace　
resource "aws_instance" "demo-tf" {
  ami = "ami-0f5ee92e2d63afc18"
  instance_type = "t2.micro"
  count = 2
  tags = {
    Name = "demo-server-tf"
  }

}
# generates random string fo 16 chars will be used give s3 names. 
resource "random_string" "myrandom" {
  length           = 16
  count = 2 # creatin two rando string, giving its index for nameing the s3 below. 
  special          = false
  upper = false
}

# create s3 bucket # bucket is global resouce  it must be usinque
  resource "aws_s3_bucket" "myBucket" {
  bucket = "my-tf-test-bucket-${count.index}"
  # or we can use random string
  # bucket = "my-tf-test-bueckt-${random_string.myrandom.id}" this var return string of 16 cahar.
  # and will be appended with "my-tf-ttest-bucket-"
  # we can also sue count.index to minimize the possiblity of duplication even after randomising
  # "my-tf-test-bucket-${random_string.myrandom[count.index]id}"
  count = 2 
  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "random_string" "myrandom" {
  length           = 16
  special          = false
  upper = false
}

# how resouces are indexed in tfstate, if we create it using count meta-args.
# how it will handle the local name in tfstate file?  see below

resource "aws_instance" "web" {
ami = data.aws_ami.redhatlatest.id
instance_type = "t2.micro"
count = 5
tags = {
"Name" = "Web" # all 5 ec2 instance will be created with same name Web
“Name” = “Web-${count.index}” # ec2 name will be Web-0, Web-1, Web-2, Web-3,..
}
}

instance name in tfstate would be like below.
aws_instance.web[0]
aws_instance.web[1]
aws_instance.web[2]
aws_instance.web[3]
aws_instance.web[4]

<providerName> _ <resourceType> . <ResourceName> <[ ]-indexNumber>


