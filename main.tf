# AWS Provider 설정
provider "aws" {
  region = "ap-northeast-2"
}

# CloudFormation 스택 종료 보호 설정
resource "aws_cloudformation_stack" "dndn_ops_agent" {
  name = "DnDn-OpsAgent"
  enable_termination_protection = true
  template_body = jsonencode({
    Resources = {}
  })

  # 기존 스택 속성 유지를 위한 lifecycle 설정
  lifecycle {
    ignore_changes = [
      template_body,
      parameters,
      capabilities
    ]
  }

  tags = {
    Environment = "Production"
    ManagedBy = "Terraform"
    SecurityDoc = "SEC-20260319-001"
    Name = "DnDn-OpsAgent"
    Owner = "Operations"
    Project = "DnDn"
  }
}