# ---------------------------------------------------------------------------
# DNS zone + TLS certificate (REFERENCE ONLY, disabled: no domain owned yet)
# Long-lived, so it lives here and is never destroyed with the environment.
#
# To enable: uncomment, set var.domain_name, apply, copy the printed
# name_servers to the registrar (skip if the domain was bought in Route 53 and
# you use its existing zone via a data source instead of creating one).
# ---------------------------------------------------------------------------

# variable "domain_name" {
#   type        = string
#   description = "Domain or subdomain served by the ALB, e.g. dev.example.com"
# }

# resource "aws_route53_zone" "main" {
#   name = var.domain_name
#
#   tags = {
#     Name = "${var.project}-zone"
#   }
# }

# resource "aws_acm_certificate" "main" {
#   domain_name       = var.domain_name
#   validation_method = "DNS"
#
#   lifecycle {
#     create_before_destroy = true
#   }
# }

# resource "aws_route53_record" "cert_validation" {
#   for_each = {
#     for dvo in aws_acm_certificate.main.domain_validation_options : dvo.domain_name => {
#       name   = dvo.resource_record_name
#       type   = dvo.resource_record_type
#       record = dvo.resource_record_value
#     }
#   }
#
#   zone_id         = aws_route53_zone.main.zone_id
#   name            = each.value.name
#   type            = each.value.type
#   records         = [each.value.record]
#   ttl             = 60
#   allow_overwrite = true
# }

# resource "aws_acm_certificate_validation" "main" {
#   certificate_arn         = aws_acm_certificate.main.arn
#   validation_record_fqdns = [for r in aws_route53_record.cert_validation : r.fqdn]
# }

# output "name_servers" {
#   value = aws_route53_zone.main.name_servers
# }
