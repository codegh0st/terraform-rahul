

variable "create-instance" {
    type = bool
    default = true
  
}

variable "availability-zone" {
  type = string
  default = "ap-south-1a"
}

# 1 example of conditional expression 
resource "aws_instance" "my-server" {
  ami = ami-abousleisldhesljlkui
  instance_type = "t2.micro"
  count = var.create-instance ? 1 : 0 # if var.create-instance is true, then create 1 instance, if false it will not create  any intance becasue value is 0

  tags = {
    "Name" = "my-server"
  }
}

# 2 example of conditional expression 
resource "aws_instance" "my-server1" {
  ami = ami-abousleisldhesljlkui
  instance_type = "t2.micro"
  count = var.availability-zone == "ap-south-1a" ? 1 : 0 # if var.availabilty-xone is equal to 'ap-south-1a', then will create intance, otherwise will not create istance. 
  tags = {
    "Name" = "my-server1"
  }
}

# SPLAT EXPRESSION EXMAPLE BELOW







