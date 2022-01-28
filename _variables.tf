variable "class_b" {
  description = "Class B of VPC (10.XXX.0.0/16)"
  default     = "100"
}

variable "key_pair_create" {
  description = "Whether to create a key pair"
  default = true
}

variable "vpn_create" {
  description = "Whether to create a VPN instance"
  default = true
}

variable "vpn_limit_ingress" {
  description = "Whether to limit the CIDR block of VPN security group inbound rules."
  default = true
}

variable "vpn_use_spot" {
  description = "Whether to use spot or on-demand EC2 instance"
  default = false
}

variable "vpn_psk" {
  description = "The IPsec Pre-Shared Key"
  type        = string
  sensitive   = true
}

variable "admin_password" {
  description = "SoftEther VPN admin / database master password"
  type        = string
  sensitive   = true
}

locals {
  owner             = "jaehyeon"
  aws_region        = data.aws_region.current.name
  resource_prefix   = "analytics"
  database_name     = "analytics"
  environment       = "dev"
  local_ip_address  = "${chomp(data.http.local_ip_address.body)}/32"
  vpn_ingress_cidr  = var.vpn_limit_ingress ? local.local_ip_address : "0.0.0.0/0"
  vpn_spot_override = [
    { instance_type: "t3.nano" },
    { instance_type: "t3a.nano" },    
  ]
}
