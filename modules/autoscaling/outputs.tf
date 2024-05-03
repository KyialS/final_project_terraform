output "autoscaling_group_name" {
  value = aws_autoscaling_group.bar.name  # Исправлено
}

output "autoscaling_group_id" {
  value = aws_autoscaling_group.bar.id
}

output "instance_ids" {
  value = {
    for group_name, group_info in aws_autoscaling_group.bar : 
    group_name => {
      instance_ids = can(group_info.instances[*]) ? [for instance in group_info.instances : instance.id] : []
    }
  }
}



output "autoscaling_group" {
  value = aws_autoscaling_group.bar
}
