variable "amiId" {
    type = string
    description = "ami to be used for crating ec2 instance"
    default = "ami-0e07dcaca348a0e68" # thi is redhat id, we can pass ubuntu id at run type, any ami id we can pass in runtype. 
  
}

variable "ec2count" {
  type = number
  description = "number of ec2 to be created"
  default = 2
}

variable "instanceType" { #if we dont pass runtime value (terraform apply -var="instanceType=t2.mediaum") then defualt value t2.micro will take. 
  type = string
  description = "intance type"
  default = "t2.micro"
}

# availability zone
variable "availability_zone" {
    type = string
    description = "if we give this variable, resouce will be created in this AZ"
    default = "ap-south-1a"
  
}

# region
variable "aws_region" {
  type = string
  description = "aws region"
  default = "ap-south-1"

}

variable "users" {
  type = list(string)
  description = "this is name of users will be created in aws"
  
}
