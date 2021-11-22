resource "aws_security_group" "worker_group_mgmt_one" {
  name_prefix = var.mgmt_one_name_prefix
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = var.mgmt_one_from_port
    to_port   = var.mgmt_one_to_port
    protocol  = var.mgmt_one_protocol

    cidr_blocks = var.mgmt_one_cidr
  }
}