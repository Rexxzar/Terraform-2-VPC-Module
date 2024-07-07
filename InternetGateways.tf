resource "aws_internet_gateway" "gw1" {
  vpc_id = aws_vpc.public-vpc.id

  tags = {
    Name = "gw for public subnet"
  }
}
resource "aws_internet_gateway" "gw2" {
  vpc_id = aws_vpc.private-vpc.id

  tags = {
    Name = "igw for private subnet"
  }
}
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.public-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw1.id
  }


  tags = {
    Name = "Route Table for the Public Subnet"
  }
}
resource "aws_route_table" "privrt" {
  vpc_id = aws_vpc.private-vpc.id
  tags = {
    Name = "Route Table for the Private Subnet"
  }
}
resource "aws_route_table_association" "rt_associate_private_2" {
  subnet_id      = aws_subnet.sb2.id
  route_table_id = aws_route_table.privrt.id
}
resource "aws_route_table_association" "pubrs" {
  subnet_id      = aws_subnet.sb1.id
  route_table_id = aws_route_table.pubrt.id

}
