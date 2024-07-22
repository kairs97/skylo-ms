# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

output "vpc_id" {
  description = "The ID of the VPC"
  value = aws_vpc.main.id
}

output "primary_subnet_id" {
  description = "The ID of the primary_subnet_id"
  value = module.primary_subnet.subnet_id
}

output "secondary_subnet_id" {
  description = "The ID of the secondary_subnet_id"
  value = module.secondary_subnet.subnet_id
}

output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = [module.primary_subnet.subnet_id, module.secondary_subnet.subnet_id]
}

output "rds_primary_subnet_id" {
  value       = module.rds_primary_subnet.subnet_id
}

output "rds_secondary_subnet_id" {
  value       = module.rds_secondary_subnet.subnet_id
}