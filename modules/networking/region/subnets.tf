# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

data "aws_availability_zones" "all" {}

module "primary_subnet" {
    source            = "../subnet"
    vpc_id            = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.all.names[0]
    cidrsubnet_netnum = 0
}

module "secondary_subnet" {
    source            = "../subnet"
    vpc_id            = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.all.names[1]
    cidrsubnet_netnum = 1
}

module "rds_primary_subnet" {
    source            = "../subnet"
    vpc_id            = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.all.names[0]
    cidrsubnet_netnum = 2
}

module "rds_secondary_subnet" {
    source            = "../subnet"
    vpc_id            = aws_vpc.main.id
    availability_zone = data.aws_availability_zones.all.names[1]
    cidrsubnet_netnum = 3
}