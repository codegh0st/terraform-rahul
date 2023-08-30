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

# creating Ubuntu instance using local variables
resource "aws_instance" "rahuls-ubuntu-server" {
    ami = var.amiId
    instance_type = var.instanceType
    count = var.ec2count
}


/*
# NOTE: How to pass value in run time?
there are multiple way to pass value in runtime eg. using -var option, environemt variable,
by creaging seperate file .

terraform apply -var="amiId=ami-ubuntudcaca348a0e68" -var="ec2count=1" -var="instanceType=t2.medium"

In root module you can create seperate file for variables 'variable.tf' 

*/