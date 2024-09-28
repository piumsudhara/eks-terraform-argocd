variable "domain_name" {
  description = "The domain name for the ACM certificate."
  type        = string
}

variable "route53_zone_id" {
  description = "The Route 53 zone ID."
  type        = string
}

variable "subnet_ids" {
  description = "The IDs of the public subnets."
  type        = list(string)
}

variable "vpc_id" {
  description = "The VPC ID."
  type        = string
}