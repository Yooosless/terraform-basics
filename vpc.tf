resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = "true"

  tags = {
    Name = "myvpc"
  }
}

#Public subnet
resource "aws_subnet" "vpc-public-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "public subnet"
  }
}

#Private Subnet
resource "aws_subnet" "vpc-private-subnet" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "private subnet"
  }
}



#Internet gateway

resource "aws_internet_gateway" "vpc-gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "vpc gateway"
  }
}

#public route table
resource "aws_route_table" "vpc-public-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-gw.id
  }

    tags = {
    Name = "vpc-public-routetables"
  }
}

#private route table
resource "aws_route_table" "vpc-private-rt" {
  vpc_id = aws_vpc.vpc.id
   route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.vpc-ngw.id
  }

    tags = {
    Name = "vpc-private-routetables"
  }
}

#public route table association
resource "aws_route_table_association" "pub-rta" {
  subnet_id      = aws_subnet.vpc-public-subnet.id
  route_table_id = aws_route_table.vpc-public-rt.id
}


#private route table association
resource "aws_route_table_association" "private-rta" {
  subnet_id      = aws_subnet.vpc-private-subnet.id
  route_table_id = aws_route_table.vpc-private-rt.id
}

#Elastic ip
resource "aws_eip" "vpc-eip" {
  domain = "vpc"

    tags = {
    Name = "eip"
  }
}

#Nat gateway
resource "aws_nat_gateway" "vpc-ngw" {
  allocation_id = aws_eip.vpc-eip.id
  subnet_id     = aws_subnet.vpc-public-subnet.id

  tags = {
    Name = "gw NAT"
  }
  depends_on = [aws_internet_gateway.vpc-gw]
}







