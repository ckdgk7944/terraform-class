# ── Security Group with Restricted Access ──
resource "aws_security_group" "demo" {
  name = "${var.project}-restricted-sg"
  description = "Security group with restricted access"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
    description = "SSH access from internal networks"
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
    description = "Outbound to internal networks"
  }

  tags = {
    Name = "${var.project}-restricted-sg"
    Environment = "demo"
    Team = "security"
    Service = "network"
  }
}
