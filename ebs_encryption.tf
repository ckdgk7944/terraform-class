resource "aws_ebs_volume" "encrypted" {
  availability_zone = "ap-northeast-2a"
  size             = 8
  type             =
  encrypted        = true
  kms_key_id       = aws_kms_key.ebs_encryption.arn

  tags = merge(
    { Name = "${var.project}-encrypted-volume" },
    var.required_tags
  )
}

resource "aws_kms_key" "ebs_encryption" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      }
    ]
  })

  tags = merge(
    { Name = "${var.project}-ebs-encryption" },
    var.required_tags
  )
}

resource "aws_kms_alias" "ebs_encryption" {
  name          = "alias/${var.project}-ebs-encryption"
  target_key_id = aws_kms_key.ebs_encryption.key_id
}

resource "aws_volume_attachment" "encrypted" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.encrypted.id
  instance_id = aws_instance.demo_secure.id
}

resource "aws_cloudtrail" "main" {
  name                          = "${var.project}-cloudtrail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  tags = merge(
    { Name = "${var.project}-cloudtrail" },
    var.required_tags
  )
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket = "${var.project}-cloudtrail-logs"
  force_destroy = true

  tags = merge(
    { Name = "${var.project}-cloudtrail-logs" },
    var.required_tags
  )
}

resource "aws_s3_bucket_server_side_encryption_configuration" "cloudtrail" {
  bucket = aws_s3_bucket.cloudtrail.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.cloudtrail.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_kms_key" "cloudtrail" {
  description             = "KMS key for CloudTrail encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "Enable IAM User Permissions"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Action   = "kms:*"
        Resource = "*"
      },
      {
        Sid    = "Allow CloudTrail to encrypt logs"
        Effect = "Allow"
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        }
        Action = [
          "kms:GenerateDataKey*",
          "kms:Decrypt"
        ]
        Resource = "*"
      }
    ]
  })

  tags = merge(
    { Name = "${var.project}-cloudtrail" },
    var.required_tags
  )
}

data "aws_caller_identity" "current" {}
