variable "region" {
  description = "AWS Region"
  default     = "ap-southeast-1"
}

variable "vpc_name" {
  description = "Name tag for the VPC"
  type        = string
  default     = "main-vpc"
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_count" {
  description = "Number of public subnets"
  type        = number
  default     = 2
}

variable "cluster_name" {
  description = "EKS Cluster name"
  default     = "my-eks-cluster"
}