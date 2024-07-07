resource "aws_db_subnet_group" "subnetgroup" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.sb1.id] # Specify your public subnet ID(s)

  tags = {
    Name = "example-db-subnet-group"
  }
}
resource "aws_db_subnet_group" "subnetgroup2" {
  name       = "my-db-subnet-group"
  subnet_ids = [aws_subnet.sb2.id] # Specify your public subnet ID(s)

  tags = {
    Name = "example-db-subnet-group"
  }
}
resource "aws_db_instance" "postgresDB" {
  identifier        = "postgres-db"
  allocated_storage = 20
  storage_type      = "gp2"
  engine            = "postgres"
  engine_version    = "12.7" # Specify the PostgreSQL version
  instance_class    = "db.t2.micro"

  username               = "admin"
  password               = "password" # Replace with your actual password
  db_subnet_group_name   = aws_db_subnet_group.subnetgroup.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  publicly_accessible    = false # Set to true to make it accessible from the internet (for demo purposes)
  multi_az               = true

  tags = {
    Name = "postgres-db"
  }
}
resource "aws_db_instance" "replica_db" {
  replicate_source_db  = aws_db_instance.postgresDB.id
  instance_class       = "db.t2.micro"
  
  username             = "admin"
  password             = "password"
  parameter_group_name = "default.postgres13"

  vpc_security_group_ids = [aws_security_group.db_sg.id] # Replace with your private VPC security group ID
  db_subnet_group_name   = aws_db_subnet_group.subnetgroup2.name
 

  tags = {
    Name = "Replica PostgreSQL DB"
  }
}