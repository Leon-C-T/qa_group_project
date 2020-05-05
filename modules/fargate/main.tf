resource "aws_eks_fargate_profile" "fargate-pets" {
  cluster_name           = var.eks-cluster-name
  fargate_profile_name   = "petclinic"
  pod_execution_role_arn = aws_iam_role.fargate-execution.arn
  subnet_ids             = var.fargate-subnets

  selector {
    namespace = "default"
  }
  selector {
    namespace = "kube-system"
    labels  = {
        "k8s-app" = "kube-dns"
    }
  }
}

resource "aws_iam_role" "fargate-execution" {
  name = "eks-fargate-petclinic"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "eks-fargate-pods.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "fargate-AmazonEKSFargatePodExecutionRolePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate-execution.name
}

resource "aws_iam_role_policy_attachment" "fargate-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.fargate-execution.name
}