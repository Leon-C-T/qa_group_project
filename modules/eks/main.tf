############################################################## EKS CLUSTER + EKS CLUSTER IAM ROLE ##############################################################

resource "aws_eks_cluster" "petclinic_eks" {
  name     = "PetClinic"    # Name of EKS Cluster on AWS
  role_arn = aws_iam_role.petrole.arn

  vpc_config {
    endpoint_private_access = false
    endpoint_public_access = true
    public_access_cidrs = ["0.0.0.0/0"]
    security_group_ids = var.secgroups
    subnet_ids = var.subnets
  }

    depends_on = [
    aws_iam_role_policy_attachment.pet-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.pet-AmazonEKSServicePolicy,
  ]
}


resource "aws_iam_role" "petrole" {
  name = "eks-petrole"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "pet-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.petrole.name
}

resource "aws_iam_role_policy_attachment" "pet-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.petrole.name
}
resource "aws_iam_role_policy_attachment" "pet-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.petrole.name
}
resource "aws_iam_role_policy_attachment" "pet-AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.petrole.name
}
resource "aws_iam_role_policy_attachment" "pet-ElasticLoadBalancingFullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
  role       = aws_iam_role.petrole.name
}