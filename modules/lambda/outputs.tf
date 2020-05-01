output "snapshot-arn" {
    description = "The resource name for lambda snapshot function"
    value       = aws_lambda_function.lambda-snapshot.arn
}

output "recovery-arn" {
    description = "The resource name for lambda recovery function"
    value = aws_lambda_function.lambda-recovery.arn
}