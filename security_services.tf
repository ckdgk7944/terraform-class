# ── GuardDuty ───────────────────────────────────────────────────────────────
resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  tags                         = merge(local.common_tags, { Name = "${local.name_prefix}-guardduty" })
}

# ── IAM Access Analyzer ────────────────────────────────────────────────────
resource "aws_accessanalyzer_analyzer" "main" {
  analyzer_name = "${local.name_prefix}-analyzer"
  type          = "ACCOUNT"
  tags          = merge(local.common_tags, { Name = "${local.name_prefix}-analyzer" })
}
