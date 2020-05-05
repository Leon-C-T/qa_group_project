variable "region" {
    description = "The Region to deploy the EKS module in (Uses value from inputs.tf)"
}
variable "lambda-subnet-ids" {
    description = "A list of subnets to attach to the lambda functions"
}
variable "lambda-security-group-ids" {
    description = "A list of security groups to attach to the lambda functions"
}