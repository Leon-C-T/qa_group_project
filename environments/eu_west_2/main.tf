module "project-vpc" {
  source         = "../../modules/vpc"
  vpc-cidr-block = "36.216.0.0/16"
  pub-sub-block1 = "36.216.1.0/24"
  pub-sub-block2 = "36.216.2.0/24"
  region         = var.region
}

module "petclinic-db" {
  source   = "../../modules/rds"
  subnetA  = module.project-vpc.public_block1_id
  subnetB  = module.project-vpc.public_block2_id
  username = var.db-username
  password = var.db-password
  region   = var.region
}


module "all_sec_grps" {
  source = "../../modules/sec_grps"
  name   = "pet_eks_secgrp"
  vpc_id = module.project-vpc.vpc_id
  region = var.region
  pub-sub-block = module.project-vpc.vpc-cidr
}

module "project-eks-cluster" {
  source    = "../../modules/eks"
  subnets   = ["${module.project-vpc.public_block1_id}", "${module.project-vpc.public_block2_id}"]
  secgroups = ["${module.all_sec_grps.aws_wsg_id}"]
  region    = var.region
  instance-type  = ["${var.instance-type-input}"]
}

