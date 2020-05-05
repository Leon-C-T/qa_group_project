variable "vpc-cidr-block" {
    description = "CIDR block for VPC"
}
variable "pub-sub-block1" {
    description = "CIDR block for public subnet 1"
}
variable "pub-sub-block2" {
    description = "CIDR block for public subnet 2"
}
variable "priv-sub-block1" {
    description = "CIDR block for private subnet 1"
}
variable "priv-sub-block2" {
    description = "CIDR block for private subnet 2"
}
variable "region" {
    description = "The Region to deploy the VPC module in (Uses value from inputs.tf)"
}
variable "sec-grps" {
    description = "Security Groups for ENI"
}