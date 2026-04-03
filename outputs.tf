# ── Network ─────────────────────────────────────────────────────────────────
output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id
}

# ── Compute ────────────────────────────────────────────────────────────────
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "web_instance_id" {
  value = aws_instance.web.id
}

output "app_instance_id" {
  value = aws_instance.app.id
}

# ── Database ───────────────────────────────────────────────────────────────
output "rds_endpoint" {
  value = aws_db_instance.main.endpoint
}

# ── Load Balancer ──────────────────────────────────────────────────────────
output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

# ── Security ───────────────────────────────────────────────────────────────
output "guardduty_detector_id" {
  value = aws_guardduty_detector.main.id
}

output "access_analyzer_arn" {
  value = aws_accessanalyzer_analyzer.main.arn
}
