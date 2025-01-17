module "vpc" {
  source              = "./modules/vpc"
  vpc_cidr_block      = var.vpc_cidr_block
  project_name        = var.project_name
  pub_sub1_cidr_block = var.pub_sub1_cidr_block
  pub_sub2_cidr_block = var.pub_sub2_cidr_block
  prv_sub1_cidr_block = var.prv_sub1_cidr_block
  prv_sub2_cidr_block = var.prv_sub2_cidr_block
}

module "nat-gw" {
  source = "./modules/NatGw"
  vpc_id = module.vpc.vpc_id
  pub-sub1-id = module.vpc.pub-sub1-id
  pub-sub2-id = module.vpc.pub-sub2-id
  prv-sub1-id = module.vpc.prv-sub1-id
  prv-sub2-id = module.vpc.prv-sub2-id
  igw_id = module.vpc.igw_id
  project_name = var.project_name
}

module "iam" {
  source = "./modules/IAM"
  project_name = var.project_name
}

module "eks" {
  source = "./modules/EKS"
  project_name = var.project_name
  eks-cluster-role-arn = module.iam.eks-cluster-role-arn
  cluster_AmazoneEKSClusterPolicy = module.iam.cluster_AmazoneEKSClusterPolicy
  pub-sub1-id = module.vpc.pub-sub1-id
  pub-sub2-id = module.vpc.pub-sub2-id
  prv-sub1-id = module.vpc.prv-sub1-id
  prv-sub2-id = module.vpc.prv-sub2-id
}

module "nodeGroup" {
  source = "./modules/nodeGroup"
  cluster_name = module.eks.cluster_name
  node_role_arn = module.iam.node_role_arn
  prv-sub1-id = module.vpc.prv-sub1-id
  prv-sub2-id = module.vpc.prv-sub2-id
}