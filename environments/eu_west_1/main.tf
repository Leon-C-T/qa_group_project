module "project-vpc" {
  source          = "../../modules/vpc"
  vpc-cidr-block  = "36.216.0.0/16"
  pub-sub-block1  = "36.216.1.0/24"
  pub-sub-block2  = "36.216.2.0/24"
  priv-sub-block1 = "36.216.10.0/24"
  priv-sub-block2 = "36.216.11.0/24"
  region          = var.region
  sec-grps        = ["${module.all_sec_grps.aws_wsg_id}"]
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
  source        = "../../modules/sec_grps"
  name          = "pet_eks_secgrp"
  vpc_id        = module.project-vpc.vpc_id
  region        = var.region
}

### -- Currently in Testing ---
#module "project-eks-cluster" {
#  source    = "../../modules/eks"
#  subnets   = ["${module.project-vpc.public_block1_id}", "${module.project-vpc.public_block2_id}", "${module.project-vpc.private_block1_id}"]
#  secgroups = ["${module.all_sec_grps.aws_wsg_id}"]
#  region    = var.region
#}
#
#module "fargate" {
#  source           = "../../modules/fargate"
#  fargate-subnets  = ["${module.project-vpc.private_block1_id}"]
#  eks-cluster-name = module.project-eks-cluster.eks-cluster-name
#  region           = var.region
#}

module "codebuild" {
  source        = "../../modules/codebuild"
  region        = var.region
  vpc-id        = module.project-vpc.vpc_id
  subnetA-arn   = module.project-vpc.public_block1_arn
  subnetA-id    = module.project-vpc.public_block1_id
  subnetB-arn   = module.project-vpc.public_block2_arn
  subnetB-id    = module.project-vpc.public_block2_id
  rds-password  = var.db-password
  rds-endpoint  = module.petclinic-db.rds-endpoint
  access-key-id = var.access-key-id
  secret-key    = var.secret-key
  sec-grps      = ["${module.all_sec_grps.aws_wsg_id}"]
}

module "cloudwatch" {
  source = "../../modules/cloudwatch"
  region = var.region
  sns-topic-slack = module.sns.recoverytopic-arn
}

module "sns" {
  source = "../../modules/sns"
  slack-arn = module.lambda.lambda-slack-arn
}

module "lambda" {
  source = "../../modules/lambda"
  region = var.region
}
