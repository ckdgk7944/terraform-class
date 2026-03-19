# 스택 이름 변수
variable "stack_name" {
  description = "CloudFormation 스택 이름"
  type        = string
  default     = "DnDn-OpsAgent"
}

# 스택 ARN 변수
variable "stack_arn" {
  description = "CloudFormation 스택 ARN"
  type        = string
  default     = "arn:aws:cloudformation:ap-northeast-2:451017115109:stack/DnDn-OpsAgent/6cecc720-2362-11f1-83e5-0aa0bd5694a3"
}