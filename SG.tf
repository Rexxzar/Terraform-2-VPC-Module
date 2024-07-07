resource "aws_security_group" "sg1" {
  vpc_id = aws_vpc.public-vpc.id
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "80 http from anywhere"
    from_port   = 80


    protocol = "tcp"


    to_port = 80
  }
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "443 allow https from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
  }
  ingress {
    cidr_blocks = ["${var.myPublicIP}"]
    description = "SSH port 22 access from one public ip only" # u can add more rules for more ip's
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"

  }
  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }




}
resource "aws_security_group" "instance_sg" {
  vpc_id = aws_vpc.public-vpc.id

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.sg1.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "instance-sg"
  }
}
resource "aws_security_group" "db_sg" {
  vpc_id = aws_vpc.public-vpc.id

  // Ingress rules: allow access from specific IPs or range (adjust as per your requirements)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow access from all IPs (not recommended for production) Place your public ip here
  }

  // Egress rules: allow outbound traffic (adjust as per your requirements)
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.redis_sg.id]
  }

  tags = {
    Name = "db-sg"
  }
}
resource "aws_security_group" "redis_sg" {
  name        = "redis-sg"
  description = "Security group for ElastiCache Redis"

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust as per your security requirements
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "redis-sg"
  }
}

