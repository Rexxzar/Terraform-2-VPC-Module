resource "aws_subnet" "sb1" {
  vpc_id     = aws_vpc.public-vpc.id
  cidr_block = "10.0.0.0/24"

  tags = {
    Name = "public-subnet"
  }
}
resource "aws_subnet" "sb2" {
  vpc_id     = aws_vpc.private-vpc.id
  cidr_block = "192.168.0.0/24"

  tags = {
    Name = "private-subnet"
  }
}