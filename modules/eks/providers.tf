# # Copyright (c) HashiCorp, Inc.
# # SPDX-License-Identifier: MPL-2.0
# terraform {
#   required_version = ">= 0.12"

#   required_providers {
#     aws = {
#       source  = "hashicorp/aws"
#       version = "~> 5.0"
#     }

#     http = {
#       source  = "hashicorp/http"
#       version = ">= 2.0"
#     }
#   }
# }

# provider "aws" {
#   region = var.aws_region
# }

# data "aws_availability_zones" "available" {}