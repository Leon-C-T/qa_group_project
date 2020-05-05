variable "region" {
    description = "The Region to deploy the RDS module in (Uses value from inputs.tf)"
}
variable "username" {
    description = "The username to create and login to the RDS Database with (Uses value from inputs.tf)"
}
variable "password" {
    description = "The password to create and login to the RDS Database with (Uses value from inputs.tf)"
}
variable "subnetA" {
    description = "The ID of Subnet 1 from VPC Module"
}
variable "subnetB" {
    description = "The ID of Subnet 2 from VPC Module"
}