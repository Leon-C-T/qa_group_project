output "rds-arn" {
    value = aws_db_instance.petclinic.db_instance_arn
}

output "rds-username" {
    value = aws_db_instance.petclinic.master_username
}

output "rds-endpoint" {
    value = aws_db_instance.petclinic.endpoint
}