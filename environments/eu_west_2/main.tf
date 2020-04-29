module "project-vpc" {
  source = "../../modules/vpc"
  vpc-cidr-block = "36.216.0.0/16"
  pub-sub-block1 = "36.216.1.0/24"
  pub-sub-block2 = "36.216.2.0/24"

  region = var.region
}

module "jenkins-ec2" {
  source      = "../../modules/ec2"
  jenkins-ami = "ami-0917237b4e71c5759"
  region      = var.region
  jenkins-sec = ["${module.eks_sec_grps.aws_jenkins_sg_id}"]
  jenkins-subnet = module.project-vpc.public_block1_id
  jenkins-key = "qapetclinic"
}

module "eks_sec_grps" {
  source = "../../modules/sec_grps"
  name   = "pet_eks_secgrp"
  vpc_id = module.project-vpc.vpc_id
  region    = var.region
}

module "project-eks-cluster" {
  source    = "../../modules/eks"
  subnets   = ["${module.project-vpc.public_block1_id}", "${module.project-vpc.public_block2_id}"]
  secgroups = ["${module.eks_sec_grps.aws_wsg_id}"]
  region    = var.region
}