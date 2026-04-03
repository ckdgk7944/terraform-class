# 보안강화된 EC2 인스턴스 생성
resource "aws_instance" "demo_secure" {
  ami           = "ami-0ecfdfd1c8ae01aec"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.demo_secure.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
    kms_key_id  = aws_kms_key.ebs_secure.arn
  }

  metadata_options {
    http_tokens = "required"
    http_endpoint = "enabled"
  }

  monitoring = true

  tags = merge(
    { Name = "${var.project}-secure" },
    var.required_tags
  )
}

# 보안강화된 보안그룹 생성
resource "aws_security_group" "demo_secure" {
  name        = "${var.project}-secure-sg"
  description = "Secure security group with restricted access"
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
    { Name = "${var.project}-secure-sg" },
    var.required_tags
  )
}

# EBS 암호화용 KMS 키 생성
resource "aws_kms_key" "ebs_secure" {
  description             = "KMS key for secure EBS encryption"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = merge(
    { Name = "${var.project}-secure-ebs-key" },
    var.required_tags
  )
}

# CloudWatch CPU 알람 설정
resource "aws_cloudwatch_metric_alarm" "secure_cpu_high" {
  alarm_name          = "${var.project}-secure-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "EC2 CPU utilization exceeds 80%"
  alarm_actions       = []

  dimensions = {
    InstanceId = aws_instance.demo_secure.id
  }

  tags = merge(
    { Name = "${var.project}-secure-cpu-alarm" },
    var.required_tags
  )
}