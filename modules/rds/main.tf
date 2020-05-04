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
}

resource "aws_db_subnet_group" "petclinic-subnet-group" {
  name       = "main"
  subnet_ids = ["${var.subnetA}", "${var.subnetB}"]

  tags = {
    Name = "Petclinic DB subnet group"
  }
}

#arn required
#username and password required
#environment variables sent to jenkins:
#var/lib/jenkins -> .bashrc file
#export username
#export password
#export URL (use endpoint)
#need database petclinic inside database
