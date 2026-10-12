data "aws_caller_identity" "current" {}

module "sem-ecs" {
  source         = ""
  VPC_ID         = module.vpc.vpc_id
  CLUSTER_NAME   = "sem-ecs"
  INSTANCE_TYPE  = "t2.small"
  SSH_KEY_NAME   = aws_key_pair.mykeypair.key_name
  VPC_SUBNETS    = join(",", module.vpc.public_subnets)
  ENABLE_SSH     = true
  SSH_SG         = aws_security_group.allow-ssh.id
  LOG_GROUP      = "sem-log-group"
  AWS_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  AWS_REGION     = var.AWS_REGION
}

module "sem-ecs-service" {
  source              = ""
  VPC_ID              = module.vpc.vpc_id
  APPLICATION_NAME    = "sem-ecs-service"
  APPLICATION_PORT    = "80"
  APPLICATION_VERSION = "latest"
  CLUSTER_ARN         = module.sem-ecs.cluster_arn
  SERVICE_ROLE_ARN    = module.sem-ecs.service_role_arn
  AWS_REGION          = var.AWS_REGION
  HEALTHCHECK_MATCHER = "200"
  CPU_RESERVATION     = "256"
  MEMORY_RESERVATION  = "256"
  LOG_GROUP           = "sem-log-group"
  DESIRED_COUNT       = 2
  ALB_ARN             = module.sem-alb.alb_arn
}

module "sem-alb" {
  source             = ""
  VPC_ID             = module.vpc.vpc_id
  ALM_NAME           = "sem-alb"
  VPC_SUBNETS        = join(",", module.vpc.public_subnets)
  DEFAULT_TARGET_ARN = module.sem-ecs-service.target_group_arn
  DOMAIN             = "*.ecs.newtech.academy"
  INTERNAL           = false
  ECS_SG             = module.sem-ecs.cluster_sg
}

module "sem-alb-rule" {
  source           = ""
  LISTENER_ARN     = module.sem-alb.http_listener_arn
  PRIORITY         = 100
  TARGET_GROUP_ARN = module.sem-ecs-service.target_group_arn
  CONDITION_FIELD  = "host-header"
  CONDITION_VALUES = ["subdomain.ecs.newtech.academy"]
}

