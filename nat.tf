resource "aws_eip" "eip" {
  vpc = true
}
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.sb1.id

  tags = {
    Name = "main-nat-gateway"
  }
}