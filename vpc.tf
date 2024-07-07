resource "aws_vpc" "public-vpc" {
  cidr_block         = "10.0.0.0/16"
  instance_tenancy   = "default"
  enable_dns_support = true
  tags = {
    Name = "public-vpc"
  }
}
resource "aws_vpc" "private-vpc" {
  cidr_block         = "192.168.0.0/16"
  instance_tenancy   = "default"
  enable_dns_support = true
  tags = {
    Name = "private-vpc"
  }
}