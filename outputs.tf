output "security_group_id" {
  description = "생성된 보안 그룹 ID"
  value       = aws_security_group.ec2_enhanced_sg.id
}

output "nacl_id" {
  description = "생성된 NACL ID"
  value       = aws_network_acl.enhanced_nacl.id
}

output "flow_log_group_name" {
  description = "VPC Flow Logs CloudWatch 로그 그룹 이름"
  value       = aws_cloudwatch_log_group.flow_log_group.name
}

output "cloudtrail_arn" {
  description = "CloudTrail ARN"
  value       = aws_cloudtrail.main.arn
}
