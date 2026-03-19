# ── Terraform 상태 저장용 버킷 ──
resource "aws_s3_bucket" "tfstate" {
  bucket = "dndn-demo-tfstate-451017115109"
  tags   = { Name = "${var.project}-tfstate" }
}

resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id
  versioning_configuration { status = "Enabled" }
}

# ── 퍼블릭 데모 버킷 (Security Hub Finding 유발) ──
# → sh-data-protection (S3.1, S3.8)
resource "aws_s3_bucket" "demo_public" {
  bucket = "dndn-demo-public-451017115109"
  tags   = { Name = "${var.project}-public" }
}

resource "aws_s3_bucket_public_access_block" "demo_public" {
  bucket                  = aws_s3_bucket.demo_public.id
  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}
