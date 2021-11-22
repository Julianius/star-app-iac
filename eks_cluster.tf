module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.20"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = var.eks_enviroment_name
  }

  vpc_id = module.vpc.vpc_id
  workers_group_defaults = var.workers_group_defaults
  worker_groups = [
    {
      name                          = var.eks_worker_groups[0].name
      instance_type                 = var.eks_worker_groups[0].instance_type
      additional_userdata           = var.eks_worker_groups[0].additional_userdata
      asg_desired_capacity          = var.eks_worker_groups[0].asg_desired_capacity
      additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
    },
  ] 
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}