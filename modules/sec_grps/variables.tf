variable "ssh-port" {
  description = "Default port for SSH protocol"
  default     = "22"
}

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

variable "ingress_ports" {
  type        = list(number)
  description = "List of ingress ports"
  default     = [80,9966,4200]
}