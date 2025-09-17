module "network" {
  source             = "../../modules/network"
  project_name       = "swayatt"
  environment        = "dev"
  vpc_cidr           = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  availability_zones = ["us-east-1a", "us-east-1b"]
}


module "ecs_cluster" {
  source       = "../../modules/ecs-cluster"
  project_name = "swayatt"
  environment  = "dev"
}

module "ecs_service" {
  source            = "../../modules/ecs-service"
  project_name      = "swayatt"
  environment       = "dev"
  region            = "us-east-1"
  ecs_cluster_id    = module.ecs_cluster.ecs_cluster_id
  app_image         = "390847198265.dkr.ecr.ap-south-1.amazonaws.com/swayatt-express-app:latest"
  vpc_id            = module.network.vpc_id
  subnets           = module.network.public_subnet_ids
  desired_count     = 2
}
