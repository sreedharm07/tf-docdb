resource "aws_docdb_subnet_group" "main" {
  name       = "${local.name}-subnetgroups"
  subnet_ids = var.subnets
  tags       = merge(local.tags, { Name = "${local.name}-subnetgroups" })
}