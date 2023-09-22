resource "aws_vpc" "demovpc" {
  cidr_block           = var.vpccidr
  enable_dns_support   = true
  enable_dns_hostnames = var.enable_dns_support

  tags = merge(var.commantags,
    { "Name" : "DemoVPC" }
  )
}

resource "aws_subnet" "demovpcpublicsubnets" {
  vpc_id            = aws_vpc.demovpc.id
  count             = length(var.publicssubentscidrs)
  cidr_block        = element(var.publicssubentscidrs, count.index)
  availability_zone = element(var.aws_availabilty_zones, count.index)
  tags = merge(var.commantags,
    {
      "Name" = "demovpc-publicsubnet-${count.index + 1}"
    }
  )
}

resource "aws_subnet" "demovpcprivatesubents" {
  vpc_id            = aws_vpc.demovpc.id
  count             = length(var.privatesubentscidrs)
  cidr_block        = element(var.privatesubentscidrs, count.index)
  availability_zone = element(var.aws_availabilty_zones, count.index)
  tags = merge(var.commantags,
    {
      "Name" = "demovpc-privatesubnet-${count.index + 1}"
    }
  )
}


resource "aws_internet_gateway" "dempvpcigw" {
  vpc_id = aws_vpc.demovpc.id
  tags = merge(var.commantags,
    {
      "Name" = "demovpc-igw"
    }
  )
}

resource "aws_route_table" "demovpcpublicrt" {
  vpc_id = aws_vpc.demovpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dempvpcigw.id
  }
  tags = merge(var.commantags,
    {
      Name = "demovpc-publicrt"
    }
  )
}

resource "aws_route_table_association" "demovpcpublicrtassociation" {
  count          = length(var.publicssubentscidrs)
  subnet_id      = element(aws_subnet.demovpcpublicsubnets[*].id, count.index)
  route_table_id = aws_route_table.demovpcpublicrt.id
}

resource "aws_eip" "nateips" {
  count = length(var.publicssubentscidrs)
  vpc = true
  tags = merge(var.commantags,
    { "Name" = "Elastic-IP-${count.index + 1}" }
  )
}

resource "aws_nat_gateway" "demovpcnatgatways" {
  count         = length(var.publicssubentscidrs)
  allocation_id = element(aws_eip.nateips[*].id, count.index)
  subnet_id     = element(aws_subnet.demovpcpublicsubnets[*].id, count.index)
  tags = merge(var.commantags,
    { "Name" = "DemoVPC-NAT-${count.index + 1}" }
  )

   depends_on = [aws_internet_gateway.dempvpcigw]
}

resource "aws_route_table" "demovpcprivateroutetable" {
  vpc_id = aws_vpc.demovpc.id
  count  = length(var.privatesubentscidrs)
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.demovpcnatgatways[*].id, count.index)
  }
  tags = merge(var.commantags, {
    Name = "demovpc-privatert-${count.index + 1}"
    }
  )
}


resource "aws_route_table_association" "demovpcnatassocation1a" {
  count          = length(var.privatesubentscidrs)
  subnet_id      = element(aws_subnet.demovpcprivatesubents[*].id, count.index)
  route_table_id = element(aws_route_table.demovpcprivateroutetable[*].id, count.index)
}
