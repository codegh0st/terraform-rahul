

locals {
  redhatAMI = "ami-alkjdokbllkjkoiuol"
  ubuntuAMI = "ami-ubunkokjlkdhoiuo32s"
  instancetypeMicro = "t2.micro"
  instancetypeMedium = "t2.medium"
  availabilityZone1a = "ap-south-1a"
  availabilityZone1b = "ap-south-1b"

  tagsDev {    # this is variable name, can give anything
    Name = "rahul"
    environment = "development"
  }

    tagsProd {  # variable name tagsProd
    Name = "rahul"
    environment = "prodection"
  }
}


# creating RHEL instance using local variables
resource "aws_instance" "rahuls-RHEL-server" {
    ami = local.redhatAMI
    instance_type = local.instancetypeMicro
    availability_zone = local.availabilityZone1a

    tags = local.tagsDev
}
# creating Ubuntu instance using local variables
resource "aws_instance" "rahuls-ubuntu-server" {
    ami = local.ubuntuAMI
    instance_type = local.instancetypeMedium
    availability_zone = local.availabilityZone1b

    tags = local.tagsProd
}

# creating s3 Bucket
resource "aws_s3_bucket" "name" {
  bucket = "teeraform-my-unique-bucket-name"
  tags =  local.tagsDev
}

