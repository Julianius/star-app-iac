data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.2.0"

  name                 = var.vpc_name
  cidr                 = var.vpc_cidr
  azs                  = data.aws_availability_zones.available.names
  private_subnets      = var.vpc_private_subnets
  public_subnets       = var.vpc_public_subnets
  enable_nat_gateway   = var.vpc_enable_nat_gateway
  single_nat_gateway   = var.vpc_single_nat_gateway
  enable_dns_hostnames = var.vpc_enable_dns_hostnames

  tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = var.vpc_tags
  }

  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = var.vpc_public_subnet_tags
    "kubernetes.io/role/elb"                      = var.vpc_public_subnet_elb
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = var.vpc_private_subnet_tags
    "kubernetes.io/role/internal-elb"             = var.vpc_private_subnet_elb
  }
}