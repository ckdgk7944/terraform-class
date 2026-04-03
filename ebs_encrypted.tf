# EBS 볼륨 암호화를 위한 KMS 키
resource "aws_kms_key" "ebs" {
  description             = "KMS key for EBS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    { Name = "${var.project}-ebs-key" },
    var.required_tags
  )
}

# 기존 EBS 볼륨 암호화 (vol-021d1fc84d912a5ad)
resource "aws_ebs_volume" "encrypted" {
  availability_zone = "ap-northeast-2a"
  size              = 8
  type              = "gp3"
  encrypted         = true
  kms_key_id        = aws_kms_key.ebs.arn

  tags = merge(
    { Name = "${var.project}-encrypted-volume" },
    var.required_tags
  )

  lifecycle {
    replace_triggered_by = [aws_kms_key.ebs.arn]
  }
}