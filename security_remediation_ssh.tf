# SSH 브루트포스 공격 대상 인스턴스에 대한 보안 강화

# 보안이 강화된 보안그룹 생성
resource "aws_security_group" "secure_ssh" {
  name        = "${var.project}-secure-ssh"
  description = "Secure security group with restricted SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
    description = "SSH access from internal networks only"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
    description = "Outbound to internal networks only"
  }

  tags = merge(
    { Name = "${var.project}-secure-ssh" },
    var.required_tags
  )
}

# 기존 취약한 EC2 인스턴스를 보안 설정으로 대체
resource "aws_instance" "secure_replacement" {
  ami           = "ami-0ecfdfd1c8ae01aec"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.secure_ssh.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
    kms_key_id  = aws_kms_key.ebs_encryption.arn
  }

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  monitoring = true

  tags = merge(
    { Name = "${var.project}-secure-replacement" },
    var.required_tags
  )
}

# CloudWatch 알람 설정 - SSH 실패 시도 모니터링
resource "aws_cloudwatch_metric_alarm" "ssh_brute_force" {
  alarm_name          = "${var.project}-ssh-brute-force"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "NetworkPacketsIn"
  namespace           = "AWS/EC2"
  period              = "300"
  statistic           = "Sum"
  threshold           = "1000"
  alarm_description   = "Monitor for SSH brute force attempts"

  dimensions = {
    InstanceId = aws_instance.secure_replacement.id
  }

  tags = merge(
    { Name = "${var.project}-ssh-alarm" },
    var.required_tags
  )
}