resource "aws_security_group" "wsg" {
  name        = var.name
  description = "For Pet QA Group Project"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress-ports
    content {
      from_port   = port.value
      protocol    = "tcp"
      to_port     = port.value
      cidr_blocks = var.open-internet
    }
  }

  egress {
    from_port   = var.outbound-port
    protocol    = "-1"
    to_port     = var.outbound-port
    cidr_blocks = var.open-internet
  }

}

resource "aws_security_group" "fargate-sg" {
  name = "fargate-security-group"
  vpc_id      = var.vpc_id
  
  dynamic "ingress" {
    iterator = port
    for_each = var.fargate-ports
    content {
      from_port   = port.value
      protocol    = "tcp"
      to_port     = port.value
      cidr_blocks = var.open-internet
    }
  }
  
  egress {
    from_port   = var.outbound-port
    to_port     = var.outbound-port
    protocol    = "-1"
    cidr_blocks = var.open-internet
  }
}
