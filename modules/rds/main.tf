# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

terraform {
    required_version = ">= 0.12"
}

# provider "aws" {
#     region = var.aws_region
# }

# RDS 생성 Resource
resource "aws_db_instance" "default" {
    depends_on              = [aws_security_group.default]
    identifier              = var.identifier
    allocated_storage       = var.storage
    engine                  = var.engine
    engine_version          = var.engine_version[var.engine]
    instance_class          = var.instance_class
    db_name                 = var.db_name
    username                = var.username
    password                = var.password
    vpc_security_group_ids  = [aws_security_group.default.id]
    db_subnet_group_name    = aws_db_subnet_group.default.id
}

# RDS Subnet Group 생성 리소스
resource "aws_db_subnet_group" "default" {
    name            = "main_subnet_group"
    description     = "Our main group of subnets"
    subnet_ids      = [var.rds_primary_subnet_id, var.rds_secondary_subnet_id]
}

