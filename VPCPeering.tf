resource "aws_vpc_peering_connection" "vpc_peering" {
  peer_vpc_id = aws_vpc.private-vpc.id # Replace with your private VPC ID
  vpc_id      = aws_vpc.public-vpc.id  # Replace with your public VPC ID
  auto_accept = true                   # Automatically accept the peering request

  tags = {
    Name = "vpc-peering-connection"
  }
}
resource "aws_route" "route_to_private_vpc" {
  route_table_id            = aws_route_table.pubrt.id
  destination_cidr_block    = aws_vpc.private-vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}
resource "aws_route" "route_to_public_vpc" {
  route_table_id            = aws_route_table.privrt.id
  destination_cidr_block    = aws_vpc.public-vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}