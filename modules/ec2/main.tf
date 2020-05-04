resource "aws_instance" "jenkins" {
  ami                    = var.jenkins-ami
  instance_type          = var.instance-type
  vpc_security_group_ids = var.jenkins-sec
  subnet_id              = var.jenkins-subnet
  key_name               = var.jenkins-key
  
  user_data = data.template_file.jenkins_install.rendered
  tags = {
    Name = "jenkins-update"
  }
  provisioner "remote-exec" {
    inline = [
      "echo 'export url=${var.db-endpoint}' >> /var/lib/jenkins/.bashrc",
      "echo 'export username=${var.db-username}' >> /var/lib/jenkins/.bashrc",
      "echo 'export password=${var.db-password}' >> /var/lib/jenkins/.bashrc"
    ]
  }
}

data "template_file" "jenkins_install" {
template = file("../../modules/ec2/jenkins.sh")
}

