resource "aws_docdb_subnet_group" "main" {
  name       = "${local.names}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(local.tags, {Name="${local.names}-subnet-group"})
}


resource "aws_docdb_cluster" "cluster" {
  cluster_identifier      = "${local.names}-cluster"
  engine                  = "docdb"
  engine_version          = var.engine_version
  master_username         = var.master_username
  master_password         = var.master_password
  backup_retention_period = var.backup_retention_period
  preferred_backup_window = var.preferred_backup_window
  skip_final_snapshot     = var.skip_final_snapshot
  db_subnet_group_name    = aws_docdb_subnet_group.main.name
  vpc_security_group_ids  = [aws_security_group.main.id]
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.main.name
}

resource "aws_docdb_cluster_parameter_group" "main" {
  family      = "docdb4.0"
  name        = "${local.names}-pg"
  description = "${local.names}-pg"
}

resource "aws_security_group" "main" {
  name        =  "${local.names}-sg"
  description = "${local.names}-sg"
  vpc_id      = var.vpc_id
  tags = merge(local.tags,{Name= "${local.names}-sg"})

  ingress {
    description      = "docdb"
    from_port        = 27017
    to_port          = 27017
    protocol         = "tcp"
    cidr_blocks      = var.sg-ingress-cidr
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_docdb_cluster_instance" "cluster_instances" {
  count              = var.count
  identifier         = "${local.names}-cluster-instance-${count.index+1}"
  cluster_identifier = aws_docdb_cluster.cluster.id
  instance_class     = var.instance_class
}
