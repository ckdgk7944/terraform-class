# KMS 키 생성
resource "aws_kms_key" "ebs_encryption" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    { Name = "${var.project}-ebs-key" },
    var.required_tags
  )
}

# EBS 볼륨 암호화 설정
resource "aws_ebs_encryption_by_default" "ebs" {
  enabled = true
}

resource "aws_ebs_default_kms_key" "ebs" {
  key_arn = aws_kms_key.ebs_encryption.arn
}

# 암호화된 EBS 볼륨
resource "aws_ebs_volume" "secure_volume" {
  availability_zone = "ap-northeast-2a"
  size             = 8
  type             = "gp3"
  encrypted        = true
  kms_key_id       = aws_kms_key.ebs_encryption.arn

  tags = merge(
    { Name = "${var.project}-secure-volume" },
    var.required_tags
  )
}