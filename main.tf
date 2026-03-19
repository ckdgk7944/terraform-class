provider "aws" {
  region = "ap-northeast-2"
}

resource "aws_security_group" "ec2_enhanced_sg" {
  name        = "ec2-enhanced-security"
  description = "강화된 EC2 보안그룹"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "HTTPS 접근"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "SSH 접근"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
    description = "HTTPS 외부 통신"
  }

  tags = {
    Name        = "ec2-enhanced-security"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_network_acl" "enhanced_nacl" {
  vpc_id = var.vpc_id

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allowed_cidr_blocks[0]
    from_port  = 443
    to_port    = 443
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.allowed_cidr_blocks[0]
    from_port  = 22
    to_port    = 22
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.allowed_cidr_blocks[0]
    from_port  = 443
    to_port    = 443
  }

  tags = {
    Name        = "enhanced-nacl"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_flow_log" "vpc_flow_log" {
  iam_role_arn    = aws_iam_role.flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id

  tags = {
    Name        = "vpc-flow-log"
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name              = "/aws/vpc/flow-logs"
  retention_in_days = 365
  kms_key_id        = aws_kms_key.log_key.arn

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_kms_key" "log_key" {
  description             = "KMS key for VPC flow logs"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_iam_role" "flow_log_role" {
  name = "vpc-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_cloudtrail" "main" {
  name                          = "main-trail"
  s3_bucket_name                = aws_s3_bucket.cloudtrail.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_logging                = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_s3_bucket" "cloudtrail" {
  bucket        = "cloudtrail-logs-${data.aws_caller_identity.current.account_id}"
  force_destroy = true

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

resource "aws_kms_key" "cloudtrail" {
  description             = "KMS key for CloudTrail"
  deletion_window_in_days = 7
  enable_key_rotation     = true

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "DevOps"
  }
}

data "aws_caller_identity" "current" {}
