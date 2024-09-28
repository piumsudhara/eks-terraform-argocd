provider "aws" {
  region = var.region
}

data "aws_eks_cluster_auth" "main" {
  name = module.eks.cluster_name
}

module "vpc" {
  source       = "../modules/vpc"
  vpc_name     = var.vpc_name
  cidr_block   = var.cidr_block
  subnet_count = var.subnet_count
}

module "eks" {
  source            = "./modules/eks"
  vpc_id            = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  subnet_ids        = module.vpc.public_subnet_ids
}

module "argocd" {
  source              = "./modules/argocd"
  cluster_name        = module.eks.cluster_name
  cluster_endpoint    = module.eks.cluster_endpoint
  cluster_certificate = module.eks.cluster_certificate
  cluster_token       = data.aws_eks_cluster_auth.main.token
}
