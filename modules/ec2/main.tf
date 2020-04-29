resource "aws_instance" "jenkins" {
  ami                    = var.jenkins-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt upgrade -y
              EOF  tags = {
    Name = "jenkins-update"
  }
}
resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9600
    to_port     = 9600
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}