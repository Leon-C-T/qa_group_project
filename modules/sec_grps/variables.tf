variable "open-internet" {
  description = "CIDR block open to the internet"
  default     = ["0.0.0.0/0"]
}
variable "outbound-port" {
  description = "Port open to allow outbound connection"
  default     = "0"
}
variable "vpc_id" {
  description = "VPC ID"
}
variable "name" {
  description = "SG Name"
  type        = string
  default     = "DefaultSG"
}
variable "ingress-ports" {
  type        = list(number)
  description = "List of ingress ports"
  default     = [80,9966,4200,3306]
}
variable "jenkins-ports" {
  description = "List of ingress ports for Jenkins"
  type        = list(number)
  default     = [8080,80,9966,4200,22]
}
variable "region" {
  description = "The Region to deploy the RDS module in (Uses value from inputs.tf)"
}
variable "pub-sub-block" {}