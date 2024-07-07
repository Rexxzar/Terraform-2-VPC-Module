
resource "aws_ecr_repository" "example_repository" {
  name = "my-repo"
}

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-cluster"
}
resource "aws_ecs_task_definition" "example_task_definition" {
  family = "example-task"
  container_definitions = jsonencode([
    {
      name      = "example-container"
      image     = "${aws_ecr_repository.example_repository.repository_url}:latest"
      cpu       = 256
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  network_mode = "awsvpc"
}
resource "aws_ecs_service" "example_service" {
  name            = "example-service"
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.example_task_definition.arn
  desired_count   = 2 # Number of instances of the task to run

  network_configuration {
    subnets          = ["subnet-abc123", "subnet-def456"] # Replace with your subnet IDs
    assign_public_ip = true                               # Assign public IP addresses to instances
    security_groups  = ["sg-12345678"]                    # Replace with your security group ID
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.SecondALBGroup.arn
    container_name   = "example-container"
    container_port   = 80
  }

  depends_on = [aws_alb_listener.example_listener]
}
resource "aws_alb_listener" "example_listener" {
  load_balancer_arn = aws_lb.ALB2.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.SecondALBGroup.arn
  }
}