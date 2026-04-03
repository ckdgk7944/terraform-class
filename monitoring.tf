# ── SNS Topic (알람 알림) ───────────────────────────────────────────────────
resource "aws_sns_topic" "alarm" {
  name = "${local.name_prefix}-alarm"
  tags = merge(local.common_tags, { Name = "${local.name_prefix}-alarm-topic" })
}

resource "aws_sns_topic_subscription" "alarm_email" {
  count     = var.alarm_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.alarm.arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# ── EC2 CPU Alarms ─────────────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "web_cpu_high" {
  alarm_name          = "${local.name_prefix}-web-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Web server CPU > 80%"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  dimensions          = { InstanceId = aws_instance.web.id }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-web-cpu-high" })
}

resource "aws_cloudwatch_metric_alarm" "app_cpu_high" {
  alarm_name          = "${local.name_prefix}-app-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "App server CPU > 80%"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  dimensions          = { InstanceId = aws_instance.app.id }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-app-cpu-high" })
}

# ── EC2 Status Check Alarm ─────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "web_status" {
  alarm_name          = "${local.name_prefix}-web-status-check"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "StatusCheckFailed"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Maximum"
  threshold           = 0
  alarm_description   = "Web server status check failed"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  dimensions          = { InstanceId = aws_instance.web.id }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-web-status" })
}

# ── RDS Alarms ─────────────────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "rds_cpu" {
  alarm_name          = "${local.name_prefix}-rds-cpu-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "RDS CPU > 80%"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  dimensions          = { DBInstanceIdentifier = aws_db_instance.main.identifier }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-rds-cpu" })
}

resource "aws_cloudwatch_metric_alarm" "rds_connections" {
  alarm_name          = "${local.name_prefix}-rds-connections-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "RDS connections > 50"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  dimensions          = { DBInstanceIdentifier = aws_db_instance.main.identifier }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-rds-connections" })
}

resource "aws_cloudwatch_metric_alarm" "rds_storage" {
  alarm_name          = "${local.name_prefix}-rds-storage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 5368709120 # 5 GB
  alarm_description   = "RDS free storage < 5GB"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  dimensions          = { DBInstanceIdentifier = aws_db_instance.main.identifier }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-rds-storage" })
}

# ── ALB Alarms ─────────────────────────────────────────────────────────────
resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${local.name_prefix}-alb-5xx-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "ALB 5xx errors > 10 in 5min"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  treat_missing_data  = "notBreaching"
  dimensions          = { LoadBalancer = aws_lb.main.arn_suffix }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-alb-5xx" })
}

resource "aws_cloudwatch_metric_alarm" "alb_latency" {
  alarm_name          = "${local.name_prefix}-alb-latency-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 300
  statistic           = "Average"
  threshold           = 3
  alarm_description   = "ALB avg response time > 3s"
  alarm_actions       = [aws_sns_topic.alarm.arn]
  treat_missing_data  = "notBreaching"
  dimensions          = { LoadBalancer = aws_lb.main.arn_suffix }
  tags                = merge(local.common_tags, { Name = "${local.name_prefix}-alb-latency" })
}
