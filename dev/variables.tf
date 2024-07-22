# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-northeast-2"
}

variable "base_cidr_block" {
  description = "List of base CIDR blocks for the VPCs"
  default = "10.0.0.0/16"  # 기본 CIDR 블록 목록
}

variable "db_password" {
  description = "rds password"
  type        = string
  sensitive   = true
}

variable "cluster_name" {
  description = "The name of EKS Cluster"
  type    = string
  default = "my-cluster"
}