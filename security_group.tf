# ── 의도적으로 취약한 SG (Security Hub Finding 유발) ──
resource "aws_security_group" "demo_open" {
  name        = "${var.project}-open-sg"
  description = "Demo SG - intentionally open for SecurityHub findings"
  vpc_id      = aws_vpc.main.id
  tags        = { Name = "${var.project}-open-sg" }

  # SSH 전체 오픈 → sh-network (EC2.13)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open to world"
  }

  # RDP 전체 오픈 → sh-network (EC2.14)
  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "RDP open to world"
  }

  # 전체 포트 오픈 → sh-network (EC2.18, EC2.19)
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All traffic open to world"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
