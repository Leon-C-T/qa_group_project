resource "aws_vpc" "vpc-module-test" {
  cidr_block           =  var.vpc-cidr-block
  enable_dns_hostnames = true
  tags = {
    Name = "vpc-module-test"
  }
}
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_subnet" "public-block1" {
  cidr_block        = var.pub-sub-block1
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.vpc-module-test.id
  map_public_ip_on_launch = true
  tags = {
        "kubernetes.io/cluster/PetClinic" = "shared"  #kubernetes.io/cluster/<name_of_cluster>
        "kubernetes.io/role/elb" = "1"
      }     
}
resource "aws_subnet" "public-block2" {
  cidr_block        = var.pub-sub-block2
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.vpc-module-test.id
  map_public_ip_on_launch = true
  tags = {
        "kubernetes.io/cluster/PetClinic" = "shared"  #kubernetes.io/cluster/<name_of_cluster>
        "kubernetes.io/role/elb" = "1"
      } 
}
resource "aws_subnet" "private-block1" {
  cidr_block        = var.priv-sub-block1
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id            = aws_vpc.vpc-module-test.id
  tags = {
        "kubernetes.io/cluster/PetClinic" = "shared"  #kubernetes.io/cluster/<name_of_cluster>
        "kubernetes.io/role/internal-elb" = "1"
      } 
}
resource "aws_subnet" "private-block2" {
  cidr_block        = var.priv-sub-block2
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id            = aws_vpc.vpc-module-test.id
  tags = {
        "kubernetes.io/cluster/PetClinic" = "shared"  #kubernetes.io/cluster/<name_of_cluster>
        "kubernetes.io/role/internal-elb" = "1"
      } 
}
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.vpc-module-test.id
  tags = {
    Name = "VPC Internet Gateway"
  }
}
resource "aws_route_table" "vpc-rt-public" {
  vpc_id = aws_vpc.vpc-module-test.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.vpc-igw.id
  }
  tags = {
    Name = "Route Table for VPC"
  }
}
resource "aws_route_table" "vpc-rt-private" {
  vpc_id = aws_vpc.vpc-module-test.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat-public.id
  }
  tags = {
    Name = "Route Table for VPC"
  }
}
resource "aws_route_table_association" "pub-sub-rta" {
  subnet_id      = aws_subnet.public-block1.id
  route_table_id = aws_route_table.vpc-rt-public.id
}
resource "aws_route_table_association" "pub-sub-rtb" {
  subnet_id      = aws_subnet.public-block2.id
  route_table_id = aws_route_table.vpc-rt-public.id
}
resource "aws_route_table_association" "priv-sub-rta" {
  subnet_id      = aws_subnet.private-block1.id
  route_table_id = aws_route_table.vpc-rt-private.id
}
resource "aws_route_table_association" "priv-sub-rtb" {
  subnet_id      = aws_subnet.private-block2.id
  route_table_id = aws_route_table.vpc-rt-private.id
}

resource "aws_nat_gateway" "nat-public" {
  allocation_id = aws_eip.fargate-eip1.id
  subnet_id = aws_subnet.public-block1.id

  depends_on = [aws_internet_gateway.vpc-igw]
}

resource "aws_nat_gateway" "nat-public2" {
  allocation_id = aws_eip.fargate-eip2.id
  subnet_id = aws_subnet.public-block2.id

  depends_on = [aws_internet_gateway.vpc-igw]
}

resource "aws_eip" "fargate-eip1" {
  vpc = true
}
resource "aws_eip" "fargate-eip2" {
  vpc = true
}


resource "aws_network_interface" "privateENI1" {
  subnet_id       = aws_subnet.private-block1.id
  security_groups = var.sec-grps
}
resource "aws_network_interface" "privateENI2" {
  subnet_id       = aws_subnet.private-block2.id
  security_groups = var.sec-grps
}