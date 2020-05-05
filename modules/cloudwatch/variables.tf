variable "region" {
    description = "The Region to deploy the cloudwatch module in (Uses value from inputs.tf)"
}
variable "jenkins-id" {
    description = "The instance id of the Jenkins EC2 instance"
}
variable "snapshot-arn" {
    description = "The AWS ARN of the Snapshot Lambda function"
}
variable "cleanup-arn" {
    description = "The AWS ARN of the Cleanup Lambda function"
}
variable "image-arn" {
    description = "The AWS ARN of the Image Lambda function"
}
variable "topic-lambdarecovery-arn" {
    description = "The AWS ARN of the SNS Topic linked to the Lambda Recovery function"
}
    