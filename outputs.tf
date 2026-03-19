output "vpc_flow_log_group" {
  description = "VPC 플로우 로그 그룹 이름"
  value       = aws_cloudwatch_log_group.vpc_flow_log_group.name
}

output "security_group_id" {
  description = "EC2 보안 그룹 ID"
  value       = aws_security_group.vec_prd_ecs_pub_2a_sg.id
}

output "vpc_flow_log_role_arn" {
  description = "VPC 플로우 로그 IAM 역할 ARN"
  value       = aws_iam_role.vpc_flow_log_role.arn
}
