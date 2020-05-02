output "endpoint" {
  value = aws_eks_cluster.petclinic_eks.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.petclinic_eks.certificate_authority.0.data
}

output "eks-asg-name" {
 value = aws_eks_node_group.petclinic_eks_nodegrp.resources.0.autoscaling_groups.0.name
}