# KMS 키 생성 (EBS 암호화용)
resource "aws_kms_key" "ebs_encryption" {
  description             = "KMS key for EBS volume encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    { Name = "${var.project}-ebs-encryption" },
    var.required_tags
  )
}

# EBS 볼륨 암호화
resource "aws_ebs_volume" "secure" {
  availability_zone = "ap-northeast-2a"
  size              = 8
  type              = "gp3"
  encrypted         = true
  kms_key_id        = aws_kms_key.ebs_encryption.arn

  tags = merge(
    { Name = "${var.project}-secure-volume" },
    var.required_tags
  )
}

# EC2 볼륨 연결
resource "aws_volume_attachment" "secure" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.secure.id
  instance_id = aws_instance.demo.id
}