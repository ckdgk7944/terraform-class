# ── Terraform State Bucket ──────────────────────────────────────────────────
resource "aws_s3_bucket" "tfstate" {
  bucket = "dndn-demo-tfstate-451017115109"
  tags   = merge(local.common_tags, { Name = "${local.name_prefix}-tfstate" })
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration { status = "Enabled" }
}

# ── Application Logs Bucket ────────────────────────────────────────────────
resource "aws_s3_bucket" "logs" {
  bucket = "${local.name_prefix}-logs-451017115109"
  tags   = merge(local.common_tags, { Name = "${local.name_prefix}-logs" })
}

resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id
  rule {
    id     = "expire-old-logs"
    status = "Enabled"
    expiration { days = 90 }
  }
}

# ── Static Assets Bucket ──────────────────────────────────────────────────
resource "aws_s3_bucket" "assets" {
  bucket = "${local.name_prefix}-assets-451017115109"
  tags   = merge(local.common_tags, { Name = "${local.name_prefix}-assets" })
}

# ── Backup Bucket ──────────────────────────────────────────────────────────
resource "aws_s3_bucket" "backup" {
  bucket = "${local.name_prefix}-backup-451017115109"
  tags   = merge(local.common_tags, { Name = "${local.name_prefix}-backup" })
}

resource "aws_s3_bucket_versioning" "backup" {
  bucket = aws_s3_bucket.backup.id
  versioning_configuration { status = "Enabled" }
}
