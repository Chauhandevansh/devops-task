output "service_name" {
  value = aws_ecs_service.swayatt-ecs-service.name
}

output "task_definition" {
  value = aws_ecs_task_definition.ECS-Task-Definition.arn
}

output "alb_dns_name" {
  value = aws_lb.swayatt-load-balancer.dns_name
}
