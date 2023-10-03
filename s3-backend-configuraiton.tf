/*
NOTE: 
s3 backetnd is block is menstioned under the terraform block, need to give profile which profile
will be used to do backend operation on s3, even though you mentions profile in provideer block
still we need ot give profile in backend block,

before configuring s3 backend and state locking, s3 bucket and mongoDB table already should be
created. 

And Also the the aws profile we useing to create resouces should have all the permisions 
realted to s3 so that he can list, describe, create delete, etc. otherwise will not able to
configure aws backend 

from tf docs.. 
dynamodb_table - (Optional) Name of DynamoDB Table to use for state locking and consistency. 
The table must have a partition key named LockID with type of String. 
If not configured, state locking will be disabled.
*/

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.19.0"
    }
  }
  backend "s3" {
    bucket = "my-unique-bucket-name "
    key    = "dev/terraform.tfstate" # this is path where terraform.tfsate will be created, s3bucket->dev->terrarom.tfsate
    region = "ap-south-1"
    dynamodb_table = "my-dynamodb-table" # name of dynamodb table, with partition key 'LockID' and type 'String'
    profile = "MyTerraformProfile" # tf will use this aws profile to do operaion on s3
  }
}

provider "aws" {
  region = "ap-south-1"
  profile = "myTerraformProfile" # tf will use this aws profile will be used to login in aws
}

# Creating EC2
resource "aws_instance" "my-server" {
    ami = "ami-lkjsdlfjsdlfjdlkf"
    instance_type = "t2.micro"
    availability_zone = "ap-south-1a"
  
}