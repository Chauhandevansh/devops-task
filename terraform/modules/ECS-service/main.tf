

resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.project_name}-${var.environment}-ecs-task-exec-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/${var.project_name}-${var.environment}-app"
  retention_in_days = 7
}


resource "aws_ecs_task_definition" "ECS-Task-Definition" {
  family                   = "${var.project_name}-${var.environment}-app"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn

  container_definitions = jsonencode([
    {
      name      = "swayatt-express-app"
      image     = var.app_image
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project_name}-${var.environment}-app"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_security_group" "swayatt_load_balancer_SG" {
  name        = "swayat-sg"
  description = "Allow traffic to ECS Fargate tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_lb" "swayatt-load-balancer" {
  name               = "${var.project_name}-${var.environment}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.swayatt_load_balancer_SG.id]
  subnets            = var.subnets
  enable_deletion_protection = false
  tags = {
    Name = "${var.project_name}-${var.environment}-alb"
  }
  depends_on = [
  aws_lb_target_group.swayatt-TG
  ]

}

resource "aws_lb_target_group" "swayatt-TG" {
  name     = "${var.project_name}-${var.environment}-tg"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"

  health_check {
    path                = "/health"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-tg"
  }
}

resource "aws_lb_listener" "swayatt-http" {
  load_balancer_arn = aws_lb.swayatt-load-balancer.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.swayatt-TG.arn
  }
}

resource "aws_security_group" "ecs_fargate_sg" {
  name        = "ecs-fargate-sg"
  description = "Allow traffic to ECS Fargate tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    security_groups = [aws_security_group.swayatt_load_balancer_SG.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "swayatt-ecs-service" {
  name            = "${var.project_name}-${var.environment}-service"
  cluster         = var.ecs_cluster_id
  task_definition = aws_ecs_task_definition.ECS-Task-Definition.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnets
    assign_public_ip = true
    security_groups  = [aws_security_group.ecs_fargate_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.swayatt-TG.arn
    container_name   = "swayatt-express-app"
    container_port   = 3000
  }

  depends_on = [
    aws_ecs_task_definition.ECS-Task-Definition,
    aws_lb_listener.swayatt-http,
    aws_cloudwatch_log_group.ecs_app
  ]
}
