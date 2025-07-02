resource "aws_ecs_cluster" "triggered-ecs" {
  name = "triggered-ecs"

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}

resource "aws_ecs_service" "teamspeak_service" {
  name            = "triggered-teamspeak"
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = aws_ecs_cluster.triggered-ecs.id
  task_definition = aws_ecs_task_definition.triggered_teamspeak_task.arn

  network_configuration {
    subnets          = [aws_default_subnet.triggered_subnet_a.id]
    security_groups  = [aws_security_group.teamspeak_sg.id]
    assign_public_ip = true
  }

  deployment_configuration {
    maximum_percent         = 100
    minimum_healthy_percent = 0
  }
}

resource "aws_ecs_task_definition" "triggered_teamspeak_task" {
  family                   = "triggered-teamspeak"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  
  container_definitions = jsonencode([
    {
      name        = "triggered-teamspeak"
      image       = "905418283206.dkr.ecr.eu-west-1.amazonaws.com/teamspeak:${var.image_tag}"
      cpu         = 256
      memory      = 512
      essential   = true
      
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.teamspeak_logs.name
          "awslogs-region"        = "eu-west-1"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      
      portMappings = [
        {
          containerPort = 9987
          protocol      = "udp"
        },
        {
          containerPort = 10011
          protocol      = "tcp"
        },
        {
          containerPort = 30033
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# IAM role for ECS task execution
resource "aws_iam_role" "ecs_execution_role" {
  name = "triggered-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_role_policy" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# CloudWatch log group with minimum retention
resource "aws_cloudwatch_log_group" "teamspeak_logs" {
  name              = "/ecs/triggered-teamspeak"
  retention_in_days = 1
}