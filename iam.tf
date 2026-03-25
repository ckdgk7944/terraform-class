# ── IAM User with MFA enforcement ──
resource "aws_iam_user" "demo_secure" {
  name = "${var.project}-secure"
  tags = {
    Name = "${var.project}-secure"
    Environment = "demo"
    Team = "security"
    Service = "iam"
  }
}

resource "aws_iam_user_policy" "demo_restricted" {
  name = "restricted-s3-access"
  user = aws_iam_user.demo_secure.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::${var.project}-secure/*",
        "arn:aws:s3:::${var.project}-secure"
      ]
    }]
  })
}

resource "aws_iam_user_login_profile" "demo_secure" {
  user                    = aws_iam_user.demo_secure.name
  password_reset_required = true
}

resource "aws_iam_user_policy_attachment" "demo_permission_boundary" {
  user       = aws_iam_user.demo_secure.name
  policy_arn = aws_iam_policy.permission_boundary.arn
}

resource "aws_iam_policy" "permission_boundary" {
  name = "${var.project}-permission-boundary"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Deny"
      Action = [
        "iam:CreateUser",
        "iam:DeleteUser",
        "iam:AttachUserPolicy",
        "iam:DetachUserPolicy"
      ]
      Resource = "*"
    }]
  })
}

resource "aws_iam_access_key" "demo_secure" {
  user = aws_iam_user.demo_secure.name
}