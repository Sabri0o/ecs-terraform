# ---------------------------------------------------------------------------
# DNS + TLS lookups and ALB-bound records (REFERENCE ONLY, disabled)
# The zone and certificate are created in accounts/dev; here we only look them up.
# ---------------------------------------------------------------------------



# data "aws_route53_zone" "main" {
#   tags = {
#     Name = "ecs-terraform-zone"
#   }
# }

# data "aws_acm_certificate" "main" {
#   domain      = var.domain_name
#   statuses    = ["ISSUED"]
#   most_recent = true
# }

# # Domain -> ALB. Lives with the ALB, so it is destroyed and recreated with it.
# resource "aws_route53_record" "alb" {
#   zone_id = data.aws_route53_zone.main.zone_id
#   name    = var.domain_name
#   type    = "A"
#
#   alias {
#     name                   = aws_lb.main.dns_name
#     zone_id                = aws_lb.main.zone_id
#     evaluate_target_health = true
#   }
# }

# # The HTTPS listener (added in alb.tf) will use data.aws_acm_certificate.main.arn
