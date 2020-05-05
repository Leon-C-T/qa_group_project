resource "aws_security_group" "wsg" {
  name        = var.name
  description = "For Pet QA Group Project"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 0
    protocol        = -1
    #security_groups = [aws_security_group.fargate-sg.id]
    to_port         = 0
    cidr_blocks     = var.open-internet
  }

  egress {
    from_port   = var.outbound-port
    protocol    = "-1"
    to_port     = var.outbound-port
    cidr_blocks = var.open-internet
  }

}

resource "aws_security_group" "fargate-sg" {
  name  = "fargate-security-group"
  vpc_id = var.vpc_id
  tags   = {
    "kubernetes.io/cluster/PetClinic" = "owned"
  }
  
  ingress {
    from_port       = 0
    protocol        = -1
    security_groups = [aws_security_group.wsg.id]
    to_port         = 0
    cidr_blocks     = var.open-internet
  }
  
  egress {
    from_port   = var.outbound-port
    to_port     = var.outbound-port
    protocol    = "-1"
    cidr_blocks = var.open-internet
  }
}
