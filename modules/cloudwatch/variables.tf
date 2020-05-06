variable "region" {
    description = "The Region to deploy the cloudwatch module in (Uses value from inputs.tf)"
}

variable "sns-topic-slack" {
    description = "Sns topic arn for slack"
}    