# 스택 종료 보호 상태 출력
output "stack_termination_protection" {
  description = "CloudFormation 스택 종료 보호 상태"
  value       = aws_cloudformation_stack.dndn_ops_agent.enable_termination_protection
}

# 스택 ARN 출력
output "stack_arn" {
  description = "CloudFormation 스택 ARN"
  value       = aws_cloudformation_stack.dndn_ops_agent.id
}