variable "region" {
    description = "The Region to deploy the EC2 module in (Uses value from inputs.tf)"
} 
variable "jenkins-ami" {
    description = "The AMI to use with the Jenkins EC2 Instance"
}  
variable "jenkins-subnet"{
    description = "The subnet for the Jenkins EC2 instance to be launched in"
}
variable "jenkins-sec" {
    description = "The security groups attached to the Jenkins EC2 instance"
}
variable "jenkins-key" {
    description = "The SSH Key to use with the Jenkins Instance as specified in the main.tf in environments"
}
variable "instance-type" {
    description = "The type of EC2 instance to be created (Uses value from inputs.tf)"
}
    
