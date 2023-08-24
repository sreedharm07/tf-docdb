resource "aws_docdb_subnet_group" "main" {
  name       = "${local.names}-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(local.tags, {Name="${local.names}-subnet-group"})
}
