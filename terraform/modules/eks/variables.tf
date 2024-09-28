variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed."
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for the EKS cluster."
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs, such as public subnets."
  type        = list(string)
}
