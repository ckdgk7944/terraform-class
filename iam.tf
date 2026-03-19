# ── MFA 없는 IAM User (Security Hub Finding 유발) ──
# → sh-iam (IAM.1, IAM.4, IAM.6)
resource "aws_iam_user" "demo_no_mfa" {
  name = "${var.project}-no-mfa"
  tags = { Name = "${var.project}-no-mfa" }
}

resource "aws_iam_user_policy_attachment" "demo_admin" {
  user       = aws_iam_user.demo_no_mfa.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

resource "aws_iam_user_policy" "demo_wildcard" {
  name   = "inline-s3-public"
  user   = aws_iam_user.demo_no_mfa.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = "s3:*"
      Resource = "*"
    }]
  })
}

resource "aws_iam_access_key" "demo_no_mfa" {
  user = aws_iam_user.demo_no_mfa.name
}
