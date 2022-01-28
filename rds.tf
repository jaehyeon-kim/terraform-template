module "rds" {
  source  = "terraform-aws-modules/rds-aurora/aws"

  name                        = "${local.resource_prefix}-db-cluster"
  engine                      = "aurora-postgresql"
  engine_version              = "13"
  auto_minor_version_upgrade  = false

  instances = {
    1 = {
      instance_class = "db.t3.medium"
    }
  }

  vpc_id                 = module.vpc.vpc_id
  db_subnet_group_name   = aws_db_subnet_group.rds.id
  create_db_subnet_group = false
  create_security_group  = true
  vpc_security_group_ids = [aws_security_group.rds.id]

  iam_database_authentication_enabled = false
  create_random_password              = false
  master_password                     = var.admin_password
  
  apply_immediately   = true
  skip_final_snapshot = true

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.rds.id
  enabled_cloudwatch_logs_exports = ["postgresql"]

  tags = {
    Name = "${local.resource_prefix}-db-cluster"
  }
}

resource "aws_db_subnet_group" "rds" {
  name       = "${local.resource_prefix}-db-subnet-group"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "${local.resource_prefix}-db-subnet-group"
  }
}

resource "aws_rds_cluster_parameter_group" "rds" {
  name        = "${local.resource_prefix}-aurora-postgres13-cluster-parameter-group"
  family      = "aurora-postgresql13"

  # for Debezium pgoutput plugin
  parameter {
    name    = "rds.logical_replication"
    value   = "1"
  }
  
  tags = {
    Name = "${local.resource_prefix}-aurora-postgres13-cluster-parameter-group"
  }
}

resource "aws_security_group" "rds" {
  name   = "${local.resource_prefix}-db-security-group"
  vpc_id = module.vpc.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "rds_vpn_inbound" {
  count                    = var.vpn_create ? 1 : 0
  type                     = "ingress"
  description              = "VPN access"
  security_group_id        = aws_security_group.rds.id
  protocol                 = "tcp"
  from_port                = "5432"
  to_port                  = "5432"
  source_security_group_id = data.aws_security_group.vpn[0].id
}