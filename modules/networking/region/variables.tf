# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "region" {
    description = "The name of the aws region to set up a network within"
}

variable "base_cidr_block" {}


variable "region_numbers" {
  default = {
    ap-northeast-1 = 0
    ap-northeast-2 = 1
    ap-northeast-3 = 2
    ap-southeast-1 = 3
  }
}