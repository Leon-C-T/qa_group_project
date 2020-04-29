module "project-vpc" {
  source = "../../modules/vpc"
  vpc-cidr-block = {
    description = "CIDR block for VPC"
    default     = "36.216.0.0/16"
  }
  pub-sub-block  = {
    description = "CIDR block for public subnet"
    default     = "36.216.1.0/24"
  }
  region         = var.region
}
module "jenkins-ec2" {
  source      = "../../modules/ec2"
  jenkins-ami = "ami-0917237b4e71c5759"
  region      = var.region
}