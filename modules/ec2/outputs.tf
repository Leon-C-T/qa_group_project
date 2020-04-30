output "public_ip" {
  value       = aws_instance.jenkins.public_ip
  description = "The public IP of the Jenkins server"
}