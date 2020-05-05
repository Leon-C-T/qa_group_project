output "aws_wsg_id" {
  value = aws_security_group.wsg.id
}
output "aws_fargate_sg_id" {
  value = aws_security_group.fargate-sg.id
}