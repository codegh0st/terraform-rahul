


locals {
  amiid = var.amiIdMap[var.osType]
}


resource "aws_instance" "rahulServer" {
  ami           = local.amiid
  instance_type = var.instanceType

# here we are merging my own tags with commonTags, comnTags is defined as variable in variables.tf
  tags = merge(var.commonTags,   
    {"name" : "my-server",
     "name2" : "my-server2"
    }
     
  )
  vpc_security_group_ids = [aws_security_group.rahul-sg] # can use multiple security gorup as a list by giving comma ["sg1","sg2"]
}




# creating security groups
resource "aws_security_group" "rahul-sg" {
  name = "rahul-server-sg"
  description = "allow port 22 and 80" 
  #vpc_id = if we dont provide vpc id this sg will be created in default vpc.

  ingress = {
    description = "allowing incoming request on 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

    ingress = {
    description = "allowing incoming request on 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress = {
    description = "allowing outgoing request on all port,protocol, and all ip-adress"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  
}



/*
Notes:

In the map (amiIdMap), we are looking for some values based on the key ('redhat','ubuntu','amazon'),

var.osType defualt value hai 'redhat', agar kuch bhi pass na keren fir bhi 'var.osType me
'readhat' raheg. 
abb, expresion banega var.amidMap['redhat'], means, amiIdMap vaiable , jo ki ek Map hai string
ka, Map "key" = "value" form me rehata hai. iske value ko fethc karne ke liye

value = variableName ['key]   use karte hai. 

iski, prakar jab hai var.amiIdMap['redhat] denge to readhat key ka jo bhi value hoga wo 
local.amiid me assign ho jayega. hamare case me redhat ka ami id assigne hoga. 

aur fir aws_instance block use kar ke redhat ka instance ban jayega. 

supopose, hame waisa os type ka instance banana hai jo, amiIDMap me define nhi kiya gaya hai,
to ham runtime me kisi bhi tpe ka ami id pass kar ke uska instance bana sakate hai,
-var="osType=ami-lkljljlsdfsd"

or we can pass default set value like this 
-var="osType=ubuntu"
-var="osType=amazon"
}

*********************
scurity groups
from_port and to_port is used to specify range of ports. 
-1 : if we ghvei -1 in protocol argument, means all protocol. 


*********************


*/