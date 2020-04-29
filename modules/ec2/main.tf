resource "aws_instance" "jenkins" {
  ami                    = var.jenkins-ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = var.jenkins-sec
  subnet_id              = var.jenkins-subnet
  key_name               = var.jenkins-key
  
  user_data = <<-EOF
              #!/bin/bash
              sudo apt update && sudo apt upgrade -y
              EOF   
  tags = {
    Name = "jenkins-update"
  }
}
output "public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "The public IP of the Jenkins server"
}