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

module "jenkins-ec2" {
  source         = "../../modules/ec2"
  jenkins-ami    = "ami-0917237b4e71c5759"
  region         = var.region
  instance-type  = var.instance-type-input
  jenkins-sec    = ["${module.all_sec_grps.aws_jenkins_sg_id}"]
  jenkins-subnet = module.project-vpc.public_block1_id
  jenkins-key    = "qapetclinic" ## Key Created on AWS
}

# --- REMOTE EXEC UNDIAGNOSED TIMEOUT --- edit: Diagnosed & Working

resource "null_resource" "test" {
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = module.jenkins-ec2.public_ip
      private_key = file("${var.key-path}")
      user = "ubuntu"
    }
    
    inline = [

      #"sudo su jenkins", # Can't change user - Provisioner doesnt match exec

      "echo 'export url=${module.petclinic-db.rds-endpoint}' >> /var/lib/jenkins/.bashrc",
      "echo 'export username=${var.db-username}' >> /var/lib/jenkins/.bashrc",
      "echo 'export password=${var.db-password}' >> /var/lib/jenkins/.bashrc",
      "sudo chown jenkins:jenkins /var/lib/jenkins/.bashrc"
      "sudo chmod 444 /var/lib/jenkins/.bashrc"
    ]
  }
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

resource "aws_autoscaling_policy" "eks-scale" {
 name                   = "eks-scale"
 policy_type            = "TargetTrackingScaling"
 autoscaling_group_name = module.project-eks-cluster.eks-asg-name

 target_tracking_configuration {
   predefined_metric_specification {
     predefined_metric_type = "ASGAverageCPUUtilization"
   }

 target_value = 80.0
 }
}

module "project-lambda-functions" {
  source                    = "../../modules/lambda"
  lambda-subnet-ids         = ["${module.project-vpc.public_block1_id}", "${module.project-vpc.public_block2_id}"]
  lambda-security-group-ids = ["${module.all_sec_grps.aws_jenkins_sg_id}"]
  region                    = var.region
}

module "project-sns-topics" {
  source       = "../../modules/sns"
  recovery-arn = "${module.project-lambda-functions.recovery-arn}"
}

module "dlm-lifecycle-deletion" {
  source = "../../modules/lifecycle"
  region = var.region
}

module "project-cloudwatch-monitoring" {
  source                   = "../../modules/cloudwatch"
  jenkins-id               = module.jenkins-ec2.jenkins-id
  snapshot-arn             = module.project-lambda-functions.snapshot-arn
  cleanup-arn              = module.project-lambda-functions.cleanup-arn
  topic-lambdarecovery-arn = ["${module.project-sns-topics.recoverytopic-arn}"]
  image-arn                = module.project-lambda-functions.image-arn
  region                   = var.region
}