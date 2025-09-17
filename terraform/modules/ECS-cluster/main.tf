# -----------------------
# ECS Cluster (Fargate)
# -----------------------
resource "aws_ecs_cluster" "swayatt-ecs-cluster" {
  name = "${var.project_name}-${var.environment}-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

