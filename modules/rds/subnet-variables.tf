# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "subnet_1_cidr" {
    default     = "10.0.1.0/24"
    description = "RDS가 사용할 subnet"
}

variable "subnet_2_cidr" {
    default     = "10.0.2.0/24"
    description = "RDS가 사용할 subnet"
}

variable "az_1" {
    default     = "ap-northeast-2a"
    description = "RDS가 사용할 가용영역"
}

variable "az_2" {
    default     = "ap-northeast-2c"
    description = "RDS가 사용할 가용영역"
}

variable "vpc_id" {
    description = "vpc_id" 
}

variable "rds_primary_subnet_id" {
    description = "rds가 사용한 서브넷"
}

variable "rds_secondary_subnet_id" {
    description = "rds가 사용한 서브넷"
}
 