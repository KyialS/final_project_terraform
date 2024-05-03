output "public_subnets_ids" {
  value = { for key, subnet in aws_subnet.public_subnets : key => subnet.id }
}

output "private_subnets_ids" {
  value = { for key, subnet in aws_subnet.private_subnets : key => subnet.id }
}


output "vpc_id" {
    value=aws_vpc.vpc.id
}