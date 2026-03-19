# VPC 플로우 로그 활성화
resource "aws_flow_log" "vec_prd_vpc_flow_log" {
  iam_role_arn    = aws_iam_role.vpc_flow_log_role.arn
  log_destination = aws_cloudwatch_log_group.vpc_flow_log_group.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vec_prd_vpc.id

  tags = {
    Name = "VEC-PRD-VPC-FLOW-LOG"
  }
}

# VPC 플로우 로그용 CloudWatch 로그 그룹
resource "aws_cloudwatch_log_group" "vpc_flow_log_group" {
  name              = "/aws/vpc/vec-prd-flow-logs"
  retention_in_days = 14

  tags = {
    Name = "VEC-PRD-VPC-FLOW-LOG-GROUP"
  }
}

# VPC 플로우 로그용 IAM 역할
resource "aws_iam_role" "vpc_flow_log_role" {
  name = "vec_prd_vpc_flow_log_role"

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
}

# VPC 플로우 로그 정책
resource "aws_iam_role_policy" "vpc_flow_log_policy" {
  name = "vec_prd_vpc_flow_log_policy"
  role = aws_iam_role.vpc_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect = "Allow"
        Resource = "*"
      }
    ]
  })
}

# EC2 보안 그룹 업데이트
resource "aws_security_group" "vec_prd_ecs_pub_2a_sg" {
  name        = "vec_prd_ecs_pub_2a_sg"
  description = "Security group for EC2 instance"
  vpc_id      = aws_vpc.vec_prd_vpc.id

  # SSH 접근 제한
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.250.0.0/16"] # VPC 내부에서만 접근 가능
  }

  # 필수 아웃바운드 규칙
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "VEC-PRD-ECS-PUB-2A-SG"
  }
}
