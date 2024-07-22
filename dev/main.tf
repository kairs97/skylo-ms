module "skylo_network" {
    source          = "../modules/networking/region"
    region          = var.region
    base_cidr_block = var.base_cidr_block
}

module "skylo_rds" {
    source                      = "../modules/rds"
    vpc_id                      = module.skylo_network.vpc_id
    password                    = var.db_password
    base_cidr_block             = var.base_cidr_block
    rds_primary_subnet_id       = module.skylo_network.rds_primary_subnet_id
    rds_secondary_subnet_id     = module.skylo_network.rds_secondary_subnet_id

    depends_on = [ module.skylo_network ]
}

module "skylo_eks" {
    source       = "../modules/eks"
    cluster_name = module.skylo_eks.cluster_name
    vpc_id       = module.skylo_network.vpc_id
    subnet_ids   = module.skylo_network.private_subnets
    
    depends_on = [ module.skylo_network ]
}
