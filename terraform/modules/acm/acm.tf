provider "aws" {
  region = "ap-southeast-1"  # Update to your preferred region
}

# ACM SSL Certificate for ArgoCD domain
resource "aws_acm_certificate" "argocd" {
  domain_name       = "argocd.lucidns.com"  # Replace with your domain
  validation_method = "DNS"

  tags = {
    Name = "argocd-cert"
  }
}

# DNS validation for the certificate using Route53
resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.argocd.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.lucidns.zone_id  # Reference your Route 53 zone ID
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.value]
}

# Route53 Hosted Zone for lucidns.com
data "aws_route53_zone" "lucidns" {
  name = "lucidns.com"  # Replace with your hosted zone name
}

# ELB for ArgoCD - Define the Load Balancer
resource "aws_lb" "argocd" {
  name               = "argocd-nlb"
  internal           = false
  load_balancer_type = "network"

  subnet_mapping {
    subnet_id = aws_subnet.public.id  # Use your public subnet IDs
  }

  tags = {
    Name = "argocd-nlb"
  }
}

# Target Group for ArgoCD service
resource "aws_lb_target_group" "argocd" {
  name     = "argocd-targets"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id  # Reference your VPC ID

  health_check {
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }

  tags = {
    Name = "argocd-targets"
  }
}

# Listener for HTTPS using the ACM certificate
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.argocd.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.argocd.arn  # Link the ACM certificate

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.argocd.arn
  }
}

# Listener for HTTP (Redirect to HTTPS)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.argocd.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      protocol = "HTTPS"
      port     = "443"
      status_code = "HTTP_301"
    }
  }
}

# Route53 A record to point to the Load Balancer
resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.lucidns.zone_id  # Use your hosted zone ID
  name    = "argocd.lucidns.com"  # Use your desired subdomain
  type    = "A"

  alias {
    name                   = aws_lb.argocd.dns_name
    zone_id                = aws_lb.argocd.zone_id
    evaluate_target_health = false
  }
}
