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
  profile = "terraformprofile" # aws configure terrafromprofile, enter details. 
}


# create ec2 instance , lifecycle demo. 
resource "aws_instance" "webServer" {
    ami =  "ami-0ec34lkjwer234"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
    tags = {
        "Name" = "nexus-server"
    }

    lifecycle {
      create_before_destroy = true # if true,  new resource will be created, then old will be desttroyed. 
      prevent_destroy = true # this doesnt allow to delete this resource, usualy used in RDS, to preent deletion of data accidently.

    }
  
}

Note: ignore_changes: suppose you have modifed some resource setting outside of terrafrom,
example you have added some tags, changed the instance type from t2.micro to t2.medium using
aws console, which means this changes is note recorded in tfstate bcz you modified outside of 
terraform,  s
So, when you give teeraform apply, teeraform will compare tfstate file and actual resouces running
and whatever is not matching with tfstate , those resources will be deleted, or those attribute
of that resource will removed. 

So, in some cases, we really need to keep those changes, with actual resources. for this
we give attributes in ignore_changes block. of lifecycle. like below.

lifecycle {
    ignore_changes = [
        tags,
        instance_type,
        ami,
        availability_zone,
        all, # if give all, all changes in any attribute will be ignored. 
    ]
}

Any changes unders this attribute will be ignored, even if tfstate file dosnt know about his
and modifed outside of terraform. 


create_before_destroy (bool) - By default, when Terraform must change a resource argument 
that cannot be updated in-place due to remote API limitations, Terraform will instead 
destroy the existing object and then create a new replacement object with the new configured 
arguments.

The create_before_destroy meta-argument changes this behavior so that the new replacement 
object is created first, and the prior object is destroyed after the replacement is created.

# depends_on lifecycle args

resource "aws_s3_bucket" "s3demo" {
bucket = "mybucketfoxinious-${random_string.randoms3name. id}"
}
resource "random_string" "randoms3name" {
upper = false
length = 16
special = false
}

In this example, terraform know, which resource is dependin on which resoure, eg. tf know
that frist i have to create random string, beacse it is reference while creating bucket,
and used in bucket name, so first tf will make random string ready, then it will be passed
to aws_s3_bucket block to create s3 bucket using this string.

BUT, Some time, tf dont understand what resource will be created 1st and what will be created
at 2nd number. in that case we have to specify create this resource 1st then create that resource

this is called implicite dependency, one antoher example is, suppose you want to create subent
for subenet you have to give vpc id, so terraform understand that i have to create vpc first
then subnet should be created.


