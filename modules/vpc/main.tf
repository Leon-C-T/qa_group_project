resource "aws_vpc" "vpc-module-test" {
  cidr_block           = var.vpc-cidr-block
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-module-test"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "public-block" {
  cidr_block        = var.pub-sub-block
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.vpc-module-test.id
}
resource "aws_internet_gateway" "vpc_igw" {
  vpc_id = aws_vpc.vpc-module-test.id
  tags = {
    Name = "VPC Internet Gateway"
  }
}
resource "aws_route_table" "vpc_rt" {
  vpc_id = aws_vpc.vpc-module-test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc_igw.id
  }
  tags = {
    Name = "Route Table for VPC"
  }
}
resource "aws_route_table_association" "pub_subA_rta" {
  subnet_id      = aws_subnet.public-block.id
  route_table_id = aws_route_table.vpc_rt.id
}