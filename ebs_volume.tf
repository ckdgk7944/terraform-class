# EBS Volume 암호화 활성화
resource "aws_ebs_volume" "encrypted_volume" {
  availability_zone = "ap-northeast-2a"
  size             = 8
  type             = "gp3"
  encrypted        = true  # Security Hub finding 수정 - EC2.3 준수
  
  tags = merge(
    { Name = "${var.project}-encrypted-volume" },
    var.required_tags
  )
}

# 기존 EC2 인스턴스에 볼륨 연결
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.encrypted_volume.id
  instance_id = aws_instance.demo.id
}

# KMS 키 생성 (EBS 암호화용)
resource "aws_kms_key" "ebs" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 7
  enable_key_rotation    = true

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
    { Name = "${var.project}-ebs-key" },
    var.required_tags
  )
}

# KMS 키 별칭 생성
resource "aws_kms_alias" "ebs" {
  name          = "alias/${var.project}-ebs-key"
  target_key_id = aws_kms_key.ebs.key_id
}

# 현재 계정 정보 조회
data "aws_caller_identity" "current" {}