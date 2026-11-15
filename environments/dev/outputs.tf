output "vpc_id" {
  value = data.aws_vpc.main.id
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}

output "public_subnet_ids" {
  value = data.aws_subnets.public.ids
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}