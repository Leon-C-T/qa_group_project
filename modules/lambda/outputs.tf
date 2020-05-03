output "snapshot-arn" {
    description = "The resource name for lambda snapshot function"
    value       = aws_lambda_function.lambda-snapshot.arn
}

output "cleanup-arn" {
    description = "The resource name for lambda cleanup function"
    value       = aws_lambda_function.lambda-cleanup.arn
}

output "image-arn" {
    description = "The resource name for lambda image function"
    value       = aws_lambda_function.lambda-image.arn
}

output "recovery-arn" {
    description = "The resource name for lambda recovery function"
    value = aws_lambda_function.lambda-recovery.arn
}