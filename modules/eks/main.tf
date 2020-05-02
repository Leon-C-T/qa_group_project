############################################################## EKS CLUSTER + EKS CLUSTER IAM ROLE ##############################################################

resource "aws_eks_cluster" "petclinic_eks" {
  name     = "PetClinic"
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

############################################################## EKS NODE GROUP + EKS NODE GROUP IAM ROLE ##############################################################

resource "aws_eks_node_group" "petclinic_eks_nodegrp" {
  cluster_name    = aws_eks_cluster.petclinic_eks.name
  node_group_name = "Pet_Clinic_Node_Groups"
  node_role_arn   = aws_iam_role.pet_role_node.arn
  subnet_ids      = var.subnets
  instance_types  = ["t2.small"]

  scaling_config {
    min_size     = 1
    max_size     = 3
    desired_size = 1
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.pet-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.pet-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.pet-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_iam_role" "pet_role_node" {
  name = "eks-pet-role-node"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "pet-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.pet_role_node.name
}

resource "aws_iam_role_policy_attachment" "pet-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.pet_role_node.name
}

resource "aws_iam_role_policy_attachment" "pet-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.pet_role_node.name
}