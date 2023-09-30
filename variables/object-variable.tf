/*
CREATE SG WITH WITHOUT REPEATING THE CODE, USE FOR_EACH FOR ITERATION
*/

#EXAMPLE MAP OF OBJECT, MAP WILL HAVE KEY VALUE PAIR
variable "my-mapof-object-sg" {
    type = map(object({  # creating skeleton of an object
      from_port = string
      to_port = string
      description = string
      cidr_blocks = list(string)
      protocol = string 
    }))
   default = {  # setting default values, ssh, http is key, in flower bracket its values
     "ssh" = {
        from_port = "22"
        to_port = "22"
        description = "allow ssh connetion"
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
     },
     "http" = {
        from_port = "80"
        to_port = "80"
        description = "allow http connetion"
        cidr_blocks = ["0.0.0.0/0"]
        protocol = "tcp"
     }
   }
}

resource "aws_security_group" "security-groups" {
  for_each = var.my-mapof-object-sg # iterating on map of object variable it will run two times
  name        = "allow_${each.key}" # in 1st iteration value will be 'allow-ssh' because here key is refered, in 2nd iteration value will be 'allow-http's
  description = "Allow port ${each.value.from_port}"

  ingress { #fetching value from map of object ("my-mapof-object-sg") in each iteration
    description      = each.value.description
    from_port        = each.value.from_port
    to_port          = each.value.to_port
    protocol         = each.value.protocols
    cidr_blocks      = [each.value.cidr_blocks]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_${each.key}"
  }
}

# Declaring output block to display the id of security group
output "sg-ids" {
    value = [ for sg in aws_security_group.security-groups: sg.id]

  # NOTE: it will return map , splat expression is used only with list, so below code will not work
  # CODE:  value = aws_security_group.security-groups[*].id  
  # it will display only id, of all elements present in security-groups object
  # in our case it will display id of two security groups 
}

resource "aws_instance" "my-server" {
    ami = "ami-klsieldkljljdojlkd"
    instance_type = "t2.micro"

    vpc_security_group_ids = [ for security in aws_security_group.security-groups: security.id ]
  
}

# Displaying some information about ec2 below
# We are creating multiple ec2 using count, so its infomation is saved in tf as list
# So we can iterate on this list of ec2 and grab the data what we want.
# in this case we are going to get the ip adress of those ec2

resource "aws_instance" "my-demo-server" {
    count = 2
    ami = "ami-llkdjfeojsdljfljlsf"
    instance_type = "t2.micro"
    vpc_security_group_ids = [ for sg in aws_security_group.security-groups: sg.id]
  
}

output "server-public-ip" {
    value = [ for ec2ip in aws_instance.my-demo-server: ec2ip.public_ip]
    # value = aws_instance.my-demo-server # it will display many info about ec2
    # value = aws_instance.my-demo-server[*].public_ip # it will display only public ip. but this complex object must be a list
    # if object is map , then use 'for' expression 
  
}


/*
explain this line :  vpc_security_group_ids = [ for security in var.my-mapof-object-sg: security.id ]
for loop is running on variable 'my-mapof-object-sg' , in each itertion one object is
comming in variable 'security' , out of that object we are fetching only id, using 'security.id'

same result can be achieved using splat expression also. 

locals  {
    count = lenght(var.my-mapof-object-sg) # jitna bhi object utna count ka value ho jayega,eg: 2
    sg-id = var.my-mapof-object-sg[count.index].id  # sg-id me object ka id store ho jayega, ye ek list banayega. sg list le leta hai. 
}

resource "aws_instance" "my-server" {
    ami = "ami-alksdlkjdflsjdfl"
    instance_type " t2.micro"
    
    vpc_security group_ids = [local.sg-id]
}

*/









#EXAMPLE LIST OF OBJECT
variable "mysecurity-group" {
    type = list(object({
      from_port = number
      to_port = number
      protocol = string
      cidr = string 
    }))

    default = [ {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr = "0.0.0.0/0"
    },
    {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr = "0.0.0.0/0"
    } ]
  
}

resource "aws_security_group" "allow-inbound" {
    name = "allow-tls"
    description = "allow inbound"
    vpc_id = aws_vpc.my-vpc.id

    ingress = {
        description = "allow port 22"
        from_port = var.mysecurity-group.from_port
        to_port = var.mysecurity-group.to_port
        protocol = var.mysecurity-group.protocol
        cidr_blocks = var.mysecurity.cidr
    }
    egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
    Name = "allow_tls"
    }
  
}