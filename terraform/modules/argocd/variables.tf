variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint of the EKS cluster"
  type        = string
}

variable "cluster_certificate" {
  description = "The certificate authority data for the EKS cluster"
  type        = string
}

variable "cluster_token" {
  description = "The authentication token for the EKS cluster"
  type        = string
}

# variable "eks_node_group_dependencies" {
#   description = "External dependencies for the EKS node group"
#   type        = list(any)
# }