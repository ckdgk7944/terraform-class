# ── S3 Bucket with Encryption and Private Access ──
resource "aws_s3_bucket" "demo" {
  bucket = "${var.project}-secure-bucket"
  force_destroy = true

  tags = {
    Name = "${var.project}-secure-bucket"
    Environment = "demo"
    Team = "security"
    Service = "storage"
  }
}

resource "aws_s3_bucket_public_access_block" "demo" {
  bucket = aws_s3_bucket.demo.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "demo" {
  bucket = aws_s3_bucket.demo.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "demo" {
  bucket = aws_s3_bucket.demo.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
