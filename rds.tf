resource "aws_db_subnet_group" "mysql-subnet" {
    name = "mysql-subnet"
    description = "RDS subnet group"
    subnet_ids = ["${aws_subnet.main-private-1.id}","${aws_subnet.main-private-2.id}"]
}

resource "aws_db_parameter_group" "mysql-parameters" {
    name = "mysql-params"
    family = "mysql5.7"
    description = "MySQL parameter group"

    parameter {
      name = "max_allowed_packet"
      value = "16777216"
   }

}


resource "aws_db_instance" "mysql" {
  allocated_storage    = 100    # 100 GB of storage, gives us more IOPS than a lower number
  engine               = "mysql"
  engine_version       = "5.7.21"
  instance_class       = "db.t2.small"    # use micro if you want to use the free tier
  identifier           = "mysql"
  name                 = "mydatabase" # database name
  username             = "root"   # username
  password             = "${var.RDS_PASSWORD}" # password
  db_subnet_group_name = "${aws_db_subnet_group.mysql-subnet.name}"
  parameter_group_name = "${aws_db_parameter_group.mysql-parameters.name}"
  multi_az             = "false"     # set to true to have high availability: 2 instances synchronized with each other
  vpc_security_group_ids = ["${aws_security_group.allow-mysql.id}"]
  storage_type         = "gp2"
  backup_retention_period = 30    # how long you’re going to keep your backups
  availability_zone = "${aws_subnet.main-private-1.availability_zone}"   # prefered AZ
  tags {
      Name = "mysql-instance"
  }
}
