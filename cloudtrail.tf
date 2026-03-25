# ── CloudTrail Configuration ──
resource "aws_cloudtrail" "demo" {
  name = "${var.project}-trail"
  s3_bucket_name = aws_s3_bucket.demo.id
  include_global_service_events = true
  is_multi_region_trail = true
  enable_logging = true

  event_selector {
    read_write_type = "All"
    include_management_events = true
  }

  tags = {
    Name = "${var.project}-trail"
    Environment = "demo"
    Team = "security"
    Service = "logging"
  }
}
