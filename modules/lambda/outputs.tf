output "recovery-arn" {
    description = "The resource name for lambda recovery function"
    value = aws_lambda_function.lambda-recovery.arn
}