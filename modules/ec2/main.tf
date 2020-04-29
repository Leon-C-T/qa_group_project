resource "aws_security_group" "jenkins-security" {
  name = "jenkins-security-group"
  
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 9966
    to_port     = 9966
    protocol    = "tcp"
    cidr_blocks = ["127.0.0.1/0"]
  }
  ingress {
    from_port   = 4200
    to_port     = 4200
    protocol    = "tcp"
    cidr_blocks = ["127.0.0.1/0"]
  }
}
resource "aws_instance" "jenkins" {
  ami                    = var.jenkins-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.jenkins-security.id]
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt upgrade -y
              EOF  tags = {
    Name = "jenkins-update"
  }
}
output "public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "The public IP of the Jenkins server"
}