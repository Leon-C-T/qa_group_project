output "vpc_id" {
  value = aws_vpc.vpc-module-test.id
}

output "public_block1_id" {
  value = aws_subnet.public-block1.id
}

output "public_block2_id" {
  value = aws_subnet.public-block2.id
}