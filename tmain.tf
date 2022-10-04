# creating networking for project

resource "aws_vpc" "July-class-tutorial" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "July-class-tutorial"
  }
}

# Public Subnet
resource "aws_subnet" "pub-subnet-1" {
  vpc_id     = "${aws_vpc.July-class-tutorial.id}"
  cidr_block = "10.0.100.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name = "pub-subnet-1"
  }
}

resource "aws_subnet" "pub-subnet-2" {
  vpc_id     = "${aws_vpc.July-class-tutorial.id}"
  cidr_block = "10.0.101.0/24"
   availability_zone = "eu-west-2a"

  tags = {
    Name = "pub-subnet-2"
  }
}

resource "aws_subnet" "pri-subnet-1" {
  vpc_id     = "${aws_vpc.July-class-tutorial.id}"
  cidr_block = "10.0.102.0/24"
   availability_zone = "eu-west-2a"

  tags = {
    Name = "pri-subnet-1"
  }
}

resource "aws_subnet" "pri-subnet-2" {
  vpc_id     = "${aws_vpc.July-class-tutorial.id}"
  cidr_block = "10.0.103.0/24"
   availability_zone = "eu-west-2a"

  tags = {
    Name = "pri-subnet-2"
  }
}

# Route Table
resource "aws_route_table" "Pub-route-1" {
  vpc_id = aws_vpc.July-class-tutorial.id


  tags = {
    Name = "Pub-route-1"
  }
}

resource "aws_route_table" "Pri-route-1" {
  vpc_id = aws_vpc.July-class-tutorial.id


  tags = {
    Name = "Pri-route-1"
  }
}
# Route Table Association
resource "aws_route_table_association" "Pub-rou-association-1" {
  subnet_id      = aws_subnet.pub-subnet-1.id
  route_table_id = aws_route_table.Pub-route-1.id
}
resource "aws_route_table_association" "Pub-rou-association-2" {
  subnet_id      = aws_subnet.pub-subnet-2.id
  route_table_id = aws_route_table.Pub-route-1.id
}
resource "aws_route_table_association" "Pri-rou-association-1" {
  subnet_id      = aws_subnet.pri-subnet-1.id
  route_table_id = aws_route_table.Pri-route-1.id
}
resource "aws_route_table_association" "Pri-rou-association-2" {
  subnet_id      = aws_subnet.pri-subnet-2.id
  route_table_id = aws_route_table.Pri-route-1.id
}

# Internet Gateway
resource "aws_internet_gateway" "Gateway-1" {
  vpc_id = aws_vpc.July-class-tutorial.id

  tags = {
    Name = "Gateway-1"
  }
}
resource "aws_route" "Pub-route-gw" {
  route_table_id            = aws_route_table.Pub-route-1.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id                = aws_internet_gateway.Gateway-1.id
}

#Elastic IP
resource "aws_eip" "Jul-class-elastic-ip" {
  vpc                       = true
    associate_with_private_ip = "10.0.104.0/24"
  }

#Nat Gateway
resource "aws_nat_gateway" "Test-nat-gateway"{
allocation_id = aws_eip.Jul-class-elastic-ip.id
subnet_id = aws_subnet.pub-subnet-1.id
}

#Route Nat IGW to Private Subnet
resource "aws_route" "Nat-gateway-association" {
  route_table_id            = aws_route_table.Pri-route-1.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id            = aws_nat_gateway.Test-nat-gateway.id
}
