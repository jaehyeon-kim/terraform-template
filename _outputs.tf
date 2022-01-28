# VPC
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

# CIDR blocks
output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

# Subnets
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

# NAT gateways
output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# AZs
output "azs" {
  description = "A list of availability zones specified as argument to this module"
  value       = module.vpc.azs
}

# AutoScaling
output "vpn_launch_template_arn" {
  description = "The ARN of the VPN launch template"
  value       = {
    for k, v in module.vpn : k => v.launch_template_arn
  }
}

output "vpn_autoscaling_group_id" {
  description = "VPN autoscaling group id"
  value       = {
    for k, v in module.vpn : k => v.autoscaling_group_id
  }
}

output "vpn_autoscaling_group_name" {
  description = "VPN autoscaling group name"
  value       = {
    for k, v in module.vpn : k => v.autoscaling_group_name
  }
}

# RDS
output "cluster_arn" {
  description = "Amazon Resource Name (ARN) of cluster"
  value       = module.rds.cluster_arn
}

output "db_subnet_group_name" {
  description = "The db subnet group name"
  value       = module.rds.db_subnet_group_name
}

output "cluster_endpoint" {
  description = "Writer endpoint for the cluster"
  value       = module.rds.cluster_endpoint
}

output "cluster_engine_version_actual" {
  description = "The running version of the cluster database"
  value       = module.rds.cluster_engine_version_actual
}

output "cluster_database_name" {
  description = "Name for an automatically created database on cluster creation"
  value       = module.rds.cluster_database_name
}

output "cluster_instances" {
  description = "A map of cluster instances and their attributes"
  value       = module.rds.cluster_instances
}

output "cluster_security_group_id" {
  description = "The security group ID of the cluster"
  value       = module.rds.security_group_id
}

output "cluster_additional_security_group_id" {
  description = "An additional security group id for VPN access"
  value       = aws_security_group.rds_additional.id
}