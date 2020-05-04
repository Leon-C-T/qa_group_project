output "rds-arn" {
    value = aws_db_instance.petclinic.arn
}

output "rds-username" {
    value = aws_db_instance.petclinic.username
}

output "rds-endpoint" {
    value = aws_db_instance.petclinic.endpoint
}