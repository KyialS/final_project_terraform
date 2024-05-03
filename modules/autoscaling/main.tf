locals {
  ingress_ports      = [22, 80, 443]
  alb_listener_ports = [80, 443, 8080]
}
resource "aws_launch_template" "foobar" {
  name_prefix            = var.name_prefix
  image_id               = data.aws_ami.ami.id
  instance_type          = var.instance_type
  vpc_security_group_ids = var.sg
  
}

resource "aws_autoscaling_group" "bar" {
  desired_capacity   = var.desired_capacity
  max_size           = var.max_size
  health_check_type         = "EC2"
  min_size           = var.min_size
  vpc_zone_identifier = var.public_subnets
  wait_for_capacity_timeout = 0

  launch_template {
    id      = aws_launch_template.foobar.id
    version = "$Default"   
  }
}

resource "aws_lb_target_group_attachment" "alb_tg_attachment" {
  for_each = {
    for key, value in aws_autoscaling_group.bar : key => value if can(value.id)
  }
  target_group_arn = var.target_group_arn
  target_id        = each.value.id
  depends_on = [aws_autoscaling_group.bar]

}


