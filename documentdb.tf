# DocumentDB Cluster
resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier       = "digidine-docdb-cluster"
  master_username          = "admin"
  master_password          = "Digidine2024!2024"
  
  # Usando o grupo de segurança existente
  vpc_security_group_ids   = ["sg-0b07368d446355324"]
  
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

  # Subnets corrigidas para a mesma VPC
  subnet_ids  = ["subnet-0c5488876c338133f", "subnet-0c8680c9b686d74ea", "subnet-0eed11c225de65036"]
}

# DocumentDB Instance
resource "aws_docdb_cluster_instance" "docdb_instance" {
  count              = 2
  identifier         = "digidine-docdb-instance-${count.index}"
  cluster_identifier = aws_docdb_cluster.docdb_cluster.id
  instance_class     = "db.t3.medium"
  apply_immediately  = true
}
