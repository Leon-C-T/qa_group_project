resource "aws_db_instance" "petclinic" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = "petclinic"
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = "petclinic_db"
  skip_final_snapshot = true
  depends_on = [aws_db_subnet_group.petclinic-subnet-group]
}

resource "aws_db_subnet_group" "petclinic-subnet-group" {
  name       = "petclinic_db"
  subnet_ids = ["${var.subnetA}", "${var.subnetB}"]

  tags = {
    Name = "Petclinic DB subnet group"
  }
}



