output "rds-arn" {
    value = aws_db_instance.petclinic.arn
}

output "rds-username" {
    value = aws_db_instance.petclinic.username
}

output "rds-endpoint" {
    # USE .address not .endpoint -> Endpoint = <address>:<port>
    value = aws_db_instance.petclinic.address
}