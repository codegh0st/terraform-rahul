
# Data Block

data "aws_ami" "redhatAmi" {
  most_recent = true # will most recent ami 
  owners = ["amazon"] # array of owners, since this ami is managed by amazon so givein amzn

  # give filters to get desired ami id for ec2 reation
  filter {
    name =  "name"
    values = "RHEL-9.0.0_HVM-20230127-x86_64-*" 
    # name = RHEL-9.0.0_HVM-20230127-×86_64-24-Hourly2-GP2"
  }  

  filter {
    name = "virualization-type"
    values = "hvm"
  }
}

# Fetch all Availability zones of the region (ap-south-1a) using Data sources
data "aws_availability_zone" "myServerAZ" {
  state = "available"
}


# use output block to display ami related informaiton
output "amiImageId" {
  value = data.aws_ami.redhatAmi.image_id
  description = " Displays ami Image Id "
  # if i give 'value = data.aws_ami.redhatAmi' it will display all the info about data.aws_ami.redhatAmi
  # above we are just looking for image_id 
  
}

# Dispay public ip of ec2
output "publicIp" {
  value = data.aws_ami.redhatAmi.public
  description = "public ip of ec2 instance created just now"
  
}

# Dislay name of all availability zone of particular region (ap-south-1)
output "listOfAZ" {
  value = data.aws_availability_zone.myServerAZ.name
  #it will display all available az eg. ap-south-1a, ap-south-ab, ap-south-1c
}

locals {
  awsAzList = data.aws_availability_zone.myServerAZ[*].names # returns list of available az in 'awsAzList'
  # it means retrun everything of list attribute. and assigne in awsAzList variable
}

output "azListByLocalBlock" {
  value = local.awsAzList # it will display the list of AZ
}

# crate ec2 instance using data sources 
resource "aws_instance" "my-server" {
  ami = data.aws_ami.redhatAmi.id
  instance_type = "t2.micro"
  availability_zone = data.aws_availability_zone.myServerAZ.name[0] # will pass 'ap-south-1a' ec2 will be created in this AZ
    tags = {
    "Name" = "redhat-server" 
  }

  
}



/*

NOTE: if any particular person, has created custom ami (MyAmi) then we can give account number
owners = ["099720109477"] 

*/