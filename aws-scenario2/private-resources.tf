resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "Security group for private rds"
  vpc_id      = aws_vpc.pub_priv_vpc.id

  # Only Postgres in
  ingress {
    from_port       = var.port
    to_port         = var.port
    protocol        = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "_" {
  name       = "rds_subnet_group"
  subnet_ids = [aws_subnet.priv_subnet1.id, aws_subnet.priv_subnet2.id]
}

resource "aws_db_instance" "db" {
  name = var.db_name

  allocated_storage    = var.db_storage
  storage_type         = var.db_storage_type
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  deletion_protection  = var.deletion_protection
  port                 = var.port
  username             = var.db_username
  password             = var.db_pass
  db_subnet_group_name = aws_db_subnet_group._.id
  multi_az             = var.multi_az
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.db_sg.id]
}

output "rds_endpoint" {
  value = aws_db_instance.db.endpoint
}