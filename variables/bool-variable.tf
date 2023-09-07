
# Boolean variable, assgning value in var.create_instance
variable "create_instance" {
    type = bool
    default = false
  
}

# String  variable, assgning value in var.create_instance
variable "create_instance2" {
    type = string
    default = "yes"
  
}

# creating ec2 instance after chekking the condiiton on basis of bolean value asinged above
resource "aws_instance" "my-server" {
  ami =   var.amiId
  instance_type = var.instanceType
  availability_zone = var.availability_zone
  count = var.create_instance? 1 : 0
}

# creating ec2 instance using string vaible type
resource "aws_instance" "my-server1" {
  ami =   var.amiId
  instance_type = var.instanceType
  availability_zone = var.availability_zone
  count = var.create_instance2 == "yes" ? 1 : 0
}

/*
count = var.create_instance? 1 : 0
this line is checking the condition of variable 'create_instance', and givin the value for 
count argument. so if value in var.create_instance is true,  then 1 will be given to count
means "count = 1" , means 1 instance will be created. 

if value of var.create_instacne is false, means conditon is false, then 0 will be paassed and
"count = 0" , means no instance will be created. 

we can use Complex experession also on place of var.create_instance to check the conditon as
we want. then we can pass the value in both of the cases. condition passed/condition failed. 



*/