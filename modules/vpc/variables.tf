variable "vpc-cidr-block" {
    description = "CIDR block for VPC"
}
variable "pub-sub-block1" {
    description = "CIDR block for public subnet1"
}
variable "pub-sub-block2" {
    description = "CIDR block for public subnet"
}
variable "region" {
    description = "The Region to deploy the VPC module in (Uses value from inputs.tf)"
}