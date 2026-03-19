# ── GuardDuty ──
resource "aws_guardduty_detector" "main" {
  enable                       = true
  finding_publishing_frequency = "FIFTEEN_MINUTES"
  tags                         = { Name = "${var.project}-guardduty" }
}

# ── IAM Access Analyzer (무료, sh-external-access 유발) ──
resource "aws_accessanalyzer_analyzer" "main" {
  analyzer_name = "${var.project}-analyzer"
  type          = "ACCOUNT"
  tags          = { Name = "${var.project}-analyzer" }
}
