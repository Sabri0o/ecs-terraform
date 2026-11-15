resource "aws_security_group" "alb" {
  name        = "${var.project}-${var.environment}-alb"
  description = "ALB: HTTP in from the internet, traffic out to the VPC"
  vpc_id      = data.aws_vpc.main.id

  tags = { Name = "${var.project}-${var.environment}-alb-sg" }
}

resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "HTTP from anywhere"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "alb_to_vpc" {
  security_group_id = aws_security_group.alb.id
  description       = "Traffic to targets inside the VPC"
  cidr_ipv4         = data.aws_vpc.main.cidr_block
  ip_protocol       = "-1"
}

resource "aws_lb" "main" {
  name               = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.alb.id]
  subnets            = data.aws_subnets.public.ids

  enable_deletion_protection = false # dev only; turn on in prod
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  # Catch-all: anything that no rule matches gets a 404.
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Nothing here"
      status_code  = "404"
    }
  }
}

# ---------------------------------------------------------------------------
# HTTPS (REFERENCE ONLY, disabled until a domain and certificate exist)
# When enabled, the HTTP listener above becomes a redirect to 443.
# ---------------------------------------------------------------------------
# resource "aws_lb_listener" "https" {
#   load_balancer_arn = aws_lb.main.arn
#   port              = 443
#   protocol          = "HTTPS"
#   ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
#   certificate_arn   = data.aws_acm_certificate.main.arn
#
#   default_action {
#     type = "fixed-response"
#     fixed_response {
#       content_type = "text/plain"
#       message_body = "Nothing here"
#       status_code  = "404"
#     }
#   }
# }