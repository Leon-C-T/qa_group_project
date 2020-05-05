output "vpc_id" {
  value = aws_vpc.vpc-module-test.id
}

output "public_block1_id" {
  value = aws_subnet.public-block1.id
}

output "public_block2_id" {
  value = aws_subnet.public-block2.id
}

output "private_block1_id" {
  value = aws_subnet.private-block1.id
}

output "public_block1_arn" {
  value = aws_subnet.public-block1.arn
}

output "public_block2_arn" {
  value = aws_subnet.public-block2.arn
}

output "private_block1_arn" {
  value = aws_subnet.private-block1.arn
}

output "vpc-cidr" {
  value = aws_vpc.vpc-module-test.cidr_block
}