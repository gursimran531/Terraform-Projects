provider "aws" {
  region = var.awsregion
}

module "vpc" {
  source = "../../modules/vpc"

  # Input variables for the VPC module
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  app_subnets    = var.app_subnets
  db_subnets     = var.db_subnets
  tags           = local.common_tags
  environment    = var.environment
}

module "asg" {
  source = "../../modules/asg_app"

  # Input variables for the ASG module
  instance_type        = var.asg_instance_type
  subnet_ids           = module.vpc.app_subnet_ids
  vpc_id               = module.vpc.vpc_id
  rds_sg               = module.rds.rds_sg_id
  create_rds           = var.create_rds
  tags                 = local.common_tags
  alb_sg               = module.alb.alb_sg
  environment          = var.environment
  instance_profile_arn = module.iam.instance_profile_arn
  tg_arn               = module.alb.tg_arn
  user_data_file       = "./scripts/nginx-cw.sh"
}

module "alb" {
  source = "../../modules/alb"

  # Input variables for the ALB module
  public_subnet_ids     = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
  asg_security_group_id = module.asg.asg_sg_id
  tags                  = local.common_tags
  environment           = var.environment
  s3_bucket_name        = module.monitoring.s3_bucket_name
}

module "rds" {
  source = "../../modules/rds"

  # Input variables for the RDS module
  create_rds    = var.create_rds
  db_subnets    = module.vpc.db_subnet_ids
  db_name       = var.db_name
  db_username   = var.db_username
  db_password   = var.db_password
  multi_az      = var.multi_az
  instance_type = var.rds_instance_type
  vpc_id        = module.vpc.vpc_id
  tags          = local.common_tags
  environment   = var.environment
  app_sg_id     = module.asg.asg_sg_id
}

module "iam" {
  source = "../../modules/iam"

  # Input variables for the IAM module
  tags        = local.common_tags
  environment = var.environment
  region      = var.awsregion
}

module "monitoring" {
  source = "../../modules/monitoring"

  # Input variables for the Monitoring module
  tags        = local.common_tags
  environment = var.environment
}

module "dns" {
  source = "../../modules/dns"

  # Input variables for the DNS module
  domain          = var.domain
  create_dns_zone = var.create_dns_zone
  environment     = var.environment
  alb_dns_name    = module.alb.alb_dns_name
  alb_zone_id     = module.alb.alb_zone_id
  tags            = local.common_tags
}