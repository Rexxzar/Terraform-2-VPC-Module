resource "aws_elasticache_subnet_group" "redis_subnet_group" {
  name       = "redis-subnet-group"
  subnet_ids = [aws_subnet.sb1.id] # Replace with your subnet IDs

  tags = {
    Name = "redis-subnet-group"
  }
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "example-redis"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1 # Adjust based on your requirements
  parameter_group_name = "default.redis6.x"
  subnet_group_name    = aws_elasticache_subnet_group.redis_subnet_group.name
  security_group_ids   = [aws_security_group.redis_sg.id]

  tags = {
    Name = "example-redis"
  }
}   