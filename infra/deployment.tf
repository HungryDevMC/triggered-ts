resource "aws_ecs_cluster" "triggered-ecs" {
  name = "triggered-ecs"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

resource "aws_ecs_service" "teamspeak_service" {
  name            = "triggered-teamspeak"
  launch_type     = "EC2"
  desired_count   = 1
  cluster         = aws_ecs_cluster.triggered-ecs.id
  task_definition = aws_ecs_task_definition.triggered_teamspeak_task.arn
}

resource "aws_ecs_task_definition" "triggered_teamspeak_task" {
  family                = "triggered-teamspeak"
  cpu                   = 512
  memory                = 1024
  network_mode          = "host"
  container_definitions = jsonencode([
    {
      name        = "triggered-teamspeak"
      image       = "905418283206.dkr.ecr.eu-west-1.amazonaws.com/teamspeak:7321a67"
      cpu         = 512
      memory      = 1024
      tty         = true
      stdin_open  = true
      essential   = true
      healthCheck = {
        command     = ["CMD-SHELL", "exit 0"]
        startPeriod = 300
        interval    = 60
      }
      portMappings = [
        {
          containerPort = 9987
          hostPort      = 9987
        },
        {
          containerPort = 10011
          hostPort      = 10011
        },
        {
          containerPort = 30033
          hostPort      = 30033
        }
      ]
    }
  ])
}