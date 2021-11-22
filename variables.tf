################## VPC ##################
variable "vpc_source" {
  type        = string
  description = "Source of the terraform module (Terraform module which creates VPC resources on AWS)."
  default     = "terraform-aws-modules/vpc/aws"
}

variable "vpc_version" {
  type        = string
  description = "Version of the terraform module (Terraform module which creates VPC resources on AWS)."
  default     = "3.2.0"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC."
  default     = "star-app-vpc"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR of the VPC."
  default     = "10.0.0.0/16"
}

variable "vpc_private_subnets" {
  type        = list(string)
  description = "Private subnets CIDR of the VPC."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "vpc_public_subnets" {
  type        = list(string)
  description = "Public subnets CIDR of the VPC."
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "vpc_enable_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision NAT Gateways for each of your private networks"
  default     = true
}

variable "vpc_single_nat_gateway" {
  type        = bool
  description = "Should be true if you want to provision a single shared NAT Gateway across all of your private networks"
  default     = true
}

variable "vpc_enable_dns_hostnames" {
  type        = bool
  description = "Should be true to enable DNS hostnames in the VPC."
  default     = true
}

variable "vpc_tags" {
  type        = string
  description = "Tags of the vpc."
  default     = "shared"
}

variable "vpc_public_subnet_tags" {
  type        = string
  description = "Public subnet tags of the vpc."
  default     = "shared"
}

variable "vpc_public_subnet_elb" {
  type        = string
  description = "External load balancer value."
  default     = "1"
}

variable "vpc_private_subnet_tags" {
  type        = string
  description = "Private subnet tags of the vpc."
  default     = "shared"
}

variable "vpc_private_subnet_elb" {
  type        = string
  description = "Internal load balancer value."
  default     = "1"
}
#########################################
##### Security Group Management One #####
variable "mgmt_one_name_prefix" {
  type        = string
  description = "Prefix name of the security group."
  default     = "worker_group_mgmt_one"
}

variable "mgmt_one_from_port" {
  type        = string
  description = "Ingress from port."
  default     = "22"
}

variable "mgmt_one_to_port" {
  type        = string
  description = "Ingress to port."
  default     = "22"
}

variable "mgmt_one_protocol" {
  type        = string
  description = "Ingress protocol."
  default     = "tcp"
}

variable "mgmt_one_cidr" {
  type        = list(string)
  description = "List of CIDR blocks."
  default     = ["10.0.0.0/8"]
}
#########################################
##### Security Group Management Two #####
variable "mgmt_two_name_prefix" {
  type        = string
  description = "Prefix name of the security group."
  default     = "worker_group_mgmt_two"
}

variable "mgmt_two_from_port" {
  type        = string
  description = "Ingress from port."
  default     = "22"
}

variable "mgmt_two_to_port" {
  type        = string
  description = "Ingress to port."
  default     = "22"
}

variable "mgmt_two_protocol" {
  type        = string
  description = "Ingress protocol."
  default     = "tcp"
}

variable "mgmt_two_cidr" {
  type        = list(string)
  description = "List of CIDR blocks."
  default     = ["192.168.0.0/16"]
}
#########################################
##### Security Group Management All #####
variable "mgmt_all_name_prefix" {
  type        = string
  description = "Prefix name of the security group."
  default     = "all_worker_management"
}

variable "mgmt_all_from_port" {
  type        = string
  description = "Ingress from port."
  default     = "22"
}

variable "mgmt_all_to_port" {
  type        = string
  description = "Ingress to port."
  default     = "22"
}

variable "mgmt_all_protocol" {
  type        = string
  description = "Ingress protocol."
  default     = "tcp"
}

variable "mgmt_all_cidr" {
  type        = list(string)
  description = "List of CIDR blocks."
  default = ["10.0.0.0/8",
    "172.16.0.0/12",
  "192.168.0.0/16"]
}
#########################################
############## EKS Cluster ##############
variable "eks_enviroment_name" {
  type        = string
  description = "EKS enviroment name."
  default     = "star_app"
}

variable "workers_group_defaults" {
  description = "EKS worker groups default configurations."
  type = object({
    root_volume_type = string
  })
  default = {
    root_volume_type = "gp2"
  }
}

variable "eks_worker_groups" {
  description = "EKS worker groups configuration."
  type = list(object({
    name                          = string
    instance_type                 = string
    additional_userdata           = string
    asg_desired_capacity          = number
    additional_security_group_ids = list(string)
  }))
  default = [{
    name                          = "worker-group-1"
    instance_type                 = "t2.large"
    additional_userdata           = "Star app worker group one."
    asg_desired_capacity          = 3
    additional_security_group_ids = []
  },
  {
    name                          = "worker-group-2"
    instance_type                 = "t2.small"
    additional_userdata           = "Star app worker group two."
    asg_desired_capacity          = 3
    additional_security_group_ids = []
  }]

}
#########################################
################# Other #################
variable "region" {
  description = "Region where we are operating."
  default     = "eu-west-3"
}

variable "shared_credentials_file_path" {
  description = "Path to where the shared credentials file location."
  default     = "/var/jenkins_home/.aws/credentials"
}

variable "aws_profile" {
  description = "AWS profile."
  default     = "default"
}
#########################################
locals {
  cluster_name = "star-app"
}
