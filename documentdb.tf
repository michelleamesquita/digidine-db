# DocumentDB Cluster
resource "aws_docdb_cluster" "docdb_cluster" {
  cluster_identifier       = "digidine-docdb-cluster"
  master_username          = var.master_username
  master_password          = var.master_password
  vpc_security_group_ids   = [aws_security_group.docdb_sg.id]
  db_subnet_group_name     = aws_docdb_subnet_group.docdb_subnet_group.name
  engine_version           = "4.0.0"  # Versão compatível com DocumentDB
  backup_retention_period  = 7        # Retenção de backup
  preferred_backup_window  = "07:00-09:00" # Horário de backup preferido
  preferred_maintenance_window = "sun:01:00-sun:03:00"
}

# DocumentDB Subnet Group
resource "aws_docdb_subnet_group" "docdb_subnet_group" {
  name       = "digidine-docdb-subnet-group"
  description = "Subnet group for DocumentDB cluster"
  subnet_ids = module.my-vpc.private_subnets
}

# Security Group para DocumentDB
resource "aws_security_group" "docdb_sg" {
  name        = "digidine-docdb-sg"
  description = "Security group for DocumentDB cluster"
  vpc_id      = module.my-vpc.vpc_id

  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.ingress_cidr_blocks  # Defina os CIDR para permitir o acesso
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"] # Saída liberada para qualquer destino
  }
}

# DocumentDB Instance
resource "aws_docdb_cluster_instance" "docdb_instance" {
  count                = 2 # Número de instâncias no cluster
  identifier           = "digidine-docdb-instance-${count.index}"
  cluster_identifier   = aws_docdb_cluster.docdb_cluster.id
  instance_class       = "db.r5.large"
  apply_immediately    = true
}

