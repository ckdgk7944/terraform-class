# ── 의도적 리소스: DnDn Advisor 점검에서 탐지되도록 생성 ────────────────────

# 미사용 Elastic IP — Advisor "미사용 EIP" 탐지
resource "aws_eip" "unused" {
  domain = "vpc"
  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-unused-eip"
    Note = "intentionally-unattached"
  })
}

# 미연결 EBS 볼륨 — Advisor "미연결 EBS" 탐지
resource "aws_ebs_volume" "unused" {
  availability_zone = var.azs[0]
  size              = 10
  type              = "gp3"
  encrypted         = false # 의도적 — SecurityHub Finding 유발

  tags = merge(local.common_tags, {
    Name = "${local.name_prefix}-unused-ebs"
    Note = "intentionally-unattached"
  })
}
