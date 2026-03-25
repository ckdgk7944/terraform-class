# MFA 강제 IAM 사용자로 변경
resource "aws_iam_user" "demo_mfa" {
  name = "${var.project}-mfa-required"
  force_destroy = true
  
  tags = merge(
    { Name = "${var.project}-mfa-required" },
    var.required_tags
  )
}

# Permission boundary 정책 생성
resource "aws_iam_policy" "user_boundary" {
  name = "${var.project}-user-boundary"
  path = "/"
  description = "Permission boundary for IAM users"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.project}-*",
          "arn:aws:s3:::${var.project}-*/*"
        ]
      }
    ]
  })
}

# MFA 조건부 정책 생성
resource "aws_iam_policy" "require_mfa" {
  name = "${var.project}-require-mfa"
  path = "/"
  description = "Policy that requires MFA"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = [
          "arn:aws:s3:::${var.project}-*",
          "arn:aws:s3:::${var.project}-*/*"
        ]
        Condition = {
          Bool = {
            "aws:MultiFactorAuthPresent": "true"
          }
        }
      }
    ]
  })
}

# Permission boundary 적용
resource "aws_iam_user_policy_attachment" "user_boundary" {
  user = aws_iam_user.demo_mfa.name
  policy_arn = aws_iam_policy.user_boundary.arn
}

# MFA 필수 정책 적용 
resource "aws_iam_user_policy_attachment" "require_mfa" {
  user = aws_iam_user.demo_mfa.name
  policy_arn = aws_iam_policy.require_mfa.arn
}

# Access key 생성
resource "aws_iam_access_key" "demo_mfa" {
  user = aws_iam_user.demo_mfa.name
}
