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
variable "db-username" {
    description = "The username to create and login to the RDS Database with"
}
variable "db-password" {
    description = "The password to create and login to the RDS Database with"
}
