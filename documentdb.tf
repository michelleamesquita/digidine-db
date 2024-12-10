# DocumentDB Cluster
resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier       = "digidine-docdb-cluster"
  master_username          = "admin"
  master_password          = "Digidine2024!2024"
  vpc_security_group_ids   = [aws_security_group.docdb_sg.id]
  db_subnet_group_name     = aws_docdb_subnet_group.docdb_subnet_group.name
  engine_version           = "4.0.0"
  backup_retention_period  = 7
  preferred_backup_window  = "07:00-09:00"
  preferred_maintenance_window = "sun:01:00-sun:03:00"
}

# DocumentDB Subnet Group
resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name        = "digidine-docdb-subnet-group"
  description = "Subnet group for DocumentDB cluster"
  subnet_ids  = ["subnet-0ed2012a602007132", "subnet-0b94c50396a512ce1", "subnet-02ab00ddbcaf406e8"]
}

# Security Group para DocumentDB
resource "aws_security_group" "docdb_sg" {
  name        = "digidine-docdb-sg"
  description = "Security group for DocumentDB cluster"
  vpc_id      = "vpc-028adccd04bfc371d"

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# DocumentDB Instance
resource "aws_docdb_cluster_instance" "docdb_instance" {
  count              = 2
  identifier         = "digidine-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = "db.t3.medium"
  apply_immediately  = true
}
