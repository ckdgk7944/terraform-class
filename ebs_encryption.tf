# EBS 볼륨 암호화를 위한 KMS 키 생성
resource "aws_kms_key" "ebs_encryption" {
  description             = "KMS key for EBS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    { Name = "${var.project}-ebs-encryption" },
    var.required_tags
  )
}

# EBS 볼륨에 암호화 적용
resource "aws_ebs_encryption_by_default" "this" {
  enabled = true
}

resource "aws_ebs_volume" "encrypted" {
  availability_zone = "ap-northeast-2a"
  size             = 8
  type             = "gp3"
  encrypted        = true
  kms_key_id       = aws_kms_key.ebs_encryption.arn

  tags = merge(
    { Name = "${var.project}-encrypted-volume" },
    var.required_tags
  )
}

# 기존 EBS 볼륨 수정을 위한 스냅샷 생성 및 암호화된 볼륨으로 교체
resource "aws_ebs_snapshot" "encrypted" {
  volume_id   = "vol-021d1fc84d912a5ad"
  description = "Encrypted snapshot from unencrypted volume"
  tags = merge(
    { Name = "${var.project}-encrypted-snapshot" },
    var.required_tags
  )
}

resource "aws_ebs_volume" "encrypted_from_snapshot" {
  availability_zone = "ap-northeast-2a"
  snapshot_id      = aws_ebs_snapshot.encrypted.id
  encrypted        = true
  kms_key_id       = aws_kms_key.ebs_encryption.arn

  tags = merge(
    { Name = "${var.project}-encrypted-from-snapshot" },
    var.required_tags
  )
}