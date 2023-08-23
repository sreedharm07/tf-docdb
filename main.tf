resource "aws_docdb_subnet_group" "main" {
  name       = "${local.name}-subnetgroups"
  subnet_ids = var.subnets
  tags       = merge(local.tags, { Name = "${local.name}-subnetgroups" })
}


resource "aws_docdb_cluster" "docdb" {
  cluster_identifier      = "my-docdb-cluster"
  engine                  = "docdb"
  master_username         = "foo"
  master_password         = "mustbeeightchars"
  backup_retention_period = 5
  preferred_backup_window = "07:00-09:00"
  skip_final_snapshot     = true
}