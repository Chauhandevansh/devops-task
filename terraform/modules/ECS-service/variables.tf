variable "project_name" { type = string }
variable "environment" { type = string }
variable "region" { type = string }

variable "ecs_cluster_id" { type = string }
variable "app_image" { type = string }

variable "subnets" { type = list(string) }
variable "vpc_id" { type = string }

variable "desired_count" {
  description = "Number of Fargate tasks to run"
  type        = number
  default     = 1
}



