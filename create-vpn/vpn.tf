

# Create a VPC
resource "aws_vpc" "foxvpc" {
  cidr_block = "192.168.0.0/24"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "foxvpc"
  }
}

# create subnet - public subnet in ap-south-1a availaibility zone
resource "aws_subnet" "pubsubnet1a" {
  vpc_id     = aws_vpc.foxvpc.id
  cidr_block = "192.168.0.0/26"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "pubsubenet1a"
  }
}

# create subnet- pvt subnet ap-south-1a
resource "aws_subnet" "pvtsubnet1a" {
  vpc_id = aws_vpc.foxvpc
  cidr_block = "192.168.0.128/26"
  availability_zone = "ap-south-1a"

  tags = {
    Name = "pvtsubnet1a"
  }
}

# create subnet - public subnet in ap-south-1b availaibility zone
resource "aws_subnet" "pubsubnet1b" {
  vpc_id     = aws_vpc.foxvpc.id
  cidr_block = "192.168.0.64/26"
  availability_zone = "ap-south-1b"
  map_public_ip_on_launch = true

  tags = {
    Name = "pubsubnet1b"
  }
}

# create subnet- pvt subnet ap-south-1b
resource "aws_subnet" "pvtsubnet1b" {
  vpc_id = aws_vpc.foxvpc
  cidr_block = "192.168.0.192/26"
  availability_zone = "ap-south-1b"

  tags = {
    Name = "pvtsubnet1b"
  }
}


# create igw - internet gateway it will allow public subnet resource to do two way communicaiton

resource "aws_internet_gateway" "foxvpcigw" {
  vpc_id = aws_vpc.foxvpc #igw will be created and will be associated with this vpc "foxvpc"

  tags = {
    Name = "foxvpcigw"
  }
}



# creating rout table,  public routs for subnet, 
#it will be associated with subnet whom i will make public
resource "aws_route_table" "foxvpcpubrout" {
  vpc_id = aws_vpc.foxvpc

  route = {
    cidr_block = "0.0.0.0/0" # if destination is this cidr, take igw raod to reach there.
    gateway_id = aws_internet_gateway.foxvpcigw.id
    
    tags = {
      Name = "foxvpcpubrout"
    }
  }
}

# aasociating route table to subnet which i want to make public,
# in in this rout already defined that it will take igw path to reach internet
# two communication if destination is any ip 0.0.0.0/0
resource "aws_route_table_association" "foxvpcpubsubnetRoutTableAssociation1b" {
  subnet_id      = aws_subnet.pubsubnet1b.id
  route_table_id = aws_route_table.foxvpcpubrout.id
}

resource "aws_route_table_association" "foxvpcpubsubnetRoutTableAssociation1a" {
  subnet_id      = aws_subnet.pubsubnet1a.id
  route_table_id = aws_route_table.foxvpcpubrout.id
}

# create Elastic IP-1 wich will be further alloacated in NatGateway
resource "aws_eip" "foxpvcNatgatewayEIP1" {
    vpc = true

    tags = {
      Name = "foxpvcNatgatewayEIP1"
    }
  
}

# create Elastic IP-2 wich will be further alloacated in NatGateway
resource "aws_eip" "foxpvcNatgatewayEIP2" {
    vpc = true

    tags = {
      Name = "foxpvcNatgatewayEIP2"
    }
  
}

# Creating 1st Nat gateway and associating it with pvt subnet later

resource "aws_nat_gateway" "foxvpcNatGateway1a" {
  allocation_id = aws_eip.foxpvcNatgatewayEIP1.id
  subnet_id     = aws_subnet.pubsubnet1a.id # nategateway will be created in pub subnet 1a AZ

  tags = {
    Name = "foxvpcNatGatewayPubSub1a"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.foxvpcigw]
}
 # creating 2nd NatGateway in 1b AZ
resource "aws_nat_gateway" "foxvpcNatGateway1b" {
  allocation_id = aws_eip.foxpvcNatgatewayEIP2.id
  subnet_id     = aws_subnet.pubsubnet1b.id # nategateway will be created in pub subnet 1b AZ

  tags = {
    Name = "foxvpcNatGatewayPubSub2b"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.foxvpcigw]
}

# Natgateway is ready, Now we have to associate this with one rout table
# so that communication starts working. 
# we can associate route table with either internat gateway or  Nat gateway. 
# igw is used when we make pubtlic rout, two way communication
# Nat gateway_id is used in pvt rout, one way communication, our resource can talk to internet
resource "aws_route_table" "foxvpcpvtrout1a" {
  vpc_id = aws_vpc.foxvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.foxvpcNatGateway1a.id

    tags = {
      Name = "foxvpcpvtrout1a"
    }
  }
}

# association of above rout table with pvt subnet 
resource "aws_route_table_association" "foxvpcPvtRoutAssociation1a" {
    subnet_id = aws_subnet.pvtsubnet1a.id
    route_table_id = aws_route_table.foxvpcpvtrout1a.id
  
}


# creating anoher rout table and in 1b AZ and associating it with pvt subnet  
resource "aws_route_table" "foxvpcpvtrout1b" {
  vpc_id = aws_vpc.foxvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.foxvpcNatGateway1b.id

    tags = {
      Name = "foxvpcpvtrout1b"
    }
  }
}

# association of above rout table with pvt subnet 
resource "aws_route_table_association" "foxvpcPvtRoutAssociation1b" {
    subnet_id = aws_subnet.pvtsubnet1b.id
    route_table_id = aws_route_table.foxvpcpvtrout1b.id
  
}

