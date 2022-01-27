module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.resource_prefix}-vpc"
  cidr = local.vpc_cidr

  azs             = ["${local.aws_region}a", "${local.aws_region}b"]
  private_subnets = ["10.${var.class_b}.0.0/19", "10.${var.class_b}.32.0/19"]
  public_subnets  = ["10.${var.class_b}.64.0/19", "10.${var.class_b}.96.0/19"]

  enable_ipv6 = false

  enable_nat_gateway = false
  single_nat_gateway = false
  one_nat_gateway_per_az = false
}

resource "tls_private_key" "pk" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "${local.resource_prefix}-key"
  public_key = tls_private_key.pk.public_key_openssh
}

resource "local_file" "pem_file" {
  filename = pathexpand("${path.module}/key-pair/${local.resource_prefix}-key.pem")
  file_permission = "0400"
  sensitive_content = tls_private_key.pk.private_key_pem
}
