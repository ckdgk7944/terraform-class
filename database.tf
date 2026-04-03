# ── RDS Subnet Group ────────────────────────────────────────────────────────
resource "aws_db_subnet_group" "main" {
  name       = "${local.name_prefix}-db-subnet"
  subnet_ids = aws_subnet.db[*].id
  tags       = merge(local.common_tags, { Name = "${local.name_prefix}-db-subnet" })
}

# ── RDS MySQL ───────────────────────────────────────────────────────────────
resource "aws_db_instance" "main" {
  identifier     = "${local.name_prefix}-mysql"
  engine         = "mysql"
  engine_version = "8.0"

  instance_class        = var.db_instance_class
  allocated_storage     = 20
  max_allocated_storage = 50
  storage_type          = "gp3"
  storage_encrypted     = false # 의도적 — SecurityHub Finding 유발

  db_name  = var.db_name
  username = var.db_username
  password = "ChangeMe123!" # 의도적 하드코딩 — 추후 Secrets Manager 전환 대상

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.db.id]

  multi_az            = false # 의도적 — Advisor 탐지 대상
  backup_retention_period = 0 # 의도적 — Advisor 탐지 대상
  skip_final_snapshot = true

  tags = merge(local.common_tags, {
    Name    = "${local.name_prefix}-mysql"
    Service = "database"
  })
}
