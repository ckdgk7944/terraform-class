# EBS 암호화 구성 
resource "aws_ebs_volume" "secure_remediated" {
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

resource "aws_volume_attachment" "secure_remediated" {
  device_name = "/dev/sdh" 
  volume_id   = aws_ebs_volume.secure_remediated.id
  instance_id = aws_instance.demo_secure.id
}