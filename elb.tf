resource "aws_lb" "ALB" {
  name               = "alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg1.id]
  subnets            = [aws_subnet.sb1.id]

  enable_deletion_protection = true

  access_logs {
    bucket  = aws_s3_bucket.log-bucket.id
    prefix  = "test-lb"
    enabled = true
  }

  tags = {
    Environment = "Dev"
  }
}
resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = "arn:aws:iam::187416307283:server-certificate/test_cert_rab3wuqwgja25ct3n4jdj2tzu4" # replace with actual cert

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.front_end.arn
  }
}
resource "aws_lb_target_group" "front_end" {
  name     = "tf-example-lb-tg"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = aws_vpc.public-vpc.id
}
resource "aws_lb" "ALB2" {
  name               = "example-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-abcdef12"]                    # Replace with your security group ID
  subnets            = [aws_subnet.sb2.id] # Replace with your subnet IDs
}

resource "aws_alb_target_group" "SecondALBGroup" {
  name     = "example-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "vpc-12345678" # Replace with your VPC ID
}


