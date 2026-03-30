# ── EC2 (퍼블릭 + 오픈 SG + 미암호화 EBS) ──
# → sh-compute, sh-data-protection, sh-network
resource "aws_instance" "demo" {
  ami                         = "ami-0ecfdfd1c8ae01aec"
  instance_type               = "t3.micro"
  subnet_id                   = aws_subnet.public_a.id
  vpc_security_group_ids      = [aws_security_group.demo_open.id]
  associate_public_ip_address = true

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = false # 의도적 미암호화 → sh-data-protection
  }

  tags = { Name = "${var.project}-vulnerable" }
}

# ── CloudWatch CPU 알람 ──
resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "${var.project}-cpu-high"
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
    InstanceId = aws_instance.demo.id
  }

  tags = { Name = "${var.project}-cpu-alarm" }
}
