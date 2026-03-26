# IAM 그룹 생성 - MFA 필수 적용을 위한 그룹
resource "aws_iam_group" "mfa_required" {
  name = "${var.project}-mfa-required-group"
  path = "/users/"
}

# 그룹 정책 생성 - MFA 필수 설정
resource "aws_iam_group_policy" "mfa_required" {
  name  = "${var.project}-mfa-required-policy"
  group = aws_iam_group.mfa_required.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid = "RequireMFAForAllActions"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
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

# 기존 유저를 그룹에 추가
resource "aws_iam_group_membership" "mfa_required" {
  name = "${var.project}-mfa-group-membership"
  users = [aws_iam_user.demo_mfa.name]
  group = aws_iam_group.mfa_required.name
}

# 기존 유저의 직접 정책 연결 제거
resource "aws_iam_user_policy_attachment" "remove_direct_policies" {
  user       = aws_iam_user.demo_mfa.name
  policy_arn = aws_iam_policy.require_mfa.arn
  depends_on = [aws_iam_group_membership.mfa_required]

  lifecycle {
    ignore_changes = [policy_arn]
  }
}
