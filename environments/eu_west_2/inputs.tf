variable "account_id" {
    description = "Your AWS Account Id e.g 042123456789"
}
variable "environment" {
    description = "Your Environment to deploy in e.g. test, production etc"
    default = "test"
}
variable "region" {
    description = "The AWS Region to deploy the infrastructure in e.g. eu-west-2"
    default = "eu-west-2"
}
variable "instance-type-input" {
    description = "The instance type for the Jenkins EC2 Instance and the EKS Node Group worker EC2 instances"
    default = "t3a.small"
}
variable "db-username" {
    description = "The username to create and login to the RDS Database with"
}
variable "db-password" {
    description = "The password to create and login to the RDS Database with"
}
variable "key-path" {
    description = "The file path to the key e.g. ../../keys/<name_of_key>. Default path = <name_of_key> (if key is located in eu_west_2 folder)."
}