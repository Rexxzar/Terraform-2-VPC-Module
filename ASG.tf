resource "aws_launch_configuration" "example" {
  name            = "example-lc"
  image_id        = "ami-12345678" # Replace with a valid AMI ID
  instance_type   = "t2.micro"
  key_name        = "your-key-pair" # Replace with your key pair
  security_groups = [aws_security_group.instance_sg.id]

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "MyASG1" {
  desired_capacity     = 4
  max_size             = 4
  min_size             = 4
  vpc_zone_identifier  = [aws_subnet.sb1.id]
  launch_configuration = aws_launch_configuration.example.id

  target_group_arns = [aws_lb_target_group.front_end.arn]

  tag {
    key                 = "Name"
    value               = "example-asg"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_nat_gateway.nat]
}
resource "aws_autoscaling_group" "MyASG2" {
  desired_capacity     = 3
  max_size             = 4
  min_size             = 1
  vpc_zone_identifier  = [aws_subnet.sb1.id]
  launch_configuration = aws_launch_configuration.example.id

  target_group_arns = [aws_lb_target_group.front_end.arn]

  tag {
    key                 = "Name"
    value               = "example-asg"
    propagate_at_launch = true
  }

  health_check_type         = "EC2"
  health_check_grace_period = 300

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_nat_gateway.nat]
}