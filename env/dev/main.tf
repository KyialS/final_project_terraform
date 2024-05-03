locals {
  ingress_ports      = [22, 80, 443]
  alb_listener_ports = [80, 443, 8080]
}
module "vpc" {
  source        = "../../modules/networking"
  public_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]

}

module "asg" {
  source             = "../../modules/autoscaling"
  public_subnets     = [module.vpc.public_subnets_ids["10.0.2.0/24"], module.vpc.private_subnets_ids["10.0.4.0/24"]]
  sg                 = [aws_security_group.sg.id]
  vpc_id             = module.vpc.vpc_id
  target_group_arn   = module.alb.default_target_group_arn
  s3_bucket_endpoint = module.s3_bucket.static_website_dns


}

resource "aws_security_group" "sg" {
  vpc_id = module.vpc.vpc_id
  dynamic "ingress" {
    for_each = toset(local.ingress_ports)
    content {
      to_port     = ingress.value
      from_port   = ingress.value
      cidr_blocks = ["0.0.0.0/0"]
      protocol    = "tcp"
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

module "alb" {
  source                           = "cloudposse/alb/aws"
  namespace                        = "alb"
  subnet_ids                       = [module.vpc.public_subnets_ids["10.0.2.0/24"], module.vpc.public_subnets_ids["10.0.1.0/24"]]
  vpc_id                           = module.vpc.vpc_id
  health_check_path                = "/health"
  health_check_port                = 80
  health_check_protocol            = "HTTP"
  health_check_timeout             = 5
  health_check_interval            = 30
  health_check_healthy_threshold   = 2
  health_check_unhealthy_threshold = 2

}

module "s3_bucket" {
  source      = "../prod"
  site_domain = "finalprojectk.com"
}
