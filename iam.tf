resource "aws_iam_user" "demo_secure" {
  name = "${var.project}-secure"
  tags = merge(
    {
      Name = "${var.project}-secure"
    },
    var.mandatory_tags
  )
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
  pgp_key                = var.pgp_key
}

resource "aws_iam_user_mfa" "demo_secure" {
  user_name = aws_iam_user.demo_secure.name
}

resource "aws_iam_role" "demo_restricted" {
  name = "${var.project}-restricted-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        AWS = aws_iam_user.demo_secure.arn
      }
      Action = "sts:AssumeRole"
    }]
  })

  permissions_boundary = aws_iam_policy.permission_boundary.arn
  tags                = var.mandatory_tags
}

resource "aws_iam_policy" "permission_boundary" {
  name = "${var.project}-permission-boundary"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Deny"
      Action = [
        "iam:*",
        "organizations:*",
        "account:*"
      ]
      Resource = "*"
    }]
  })
}
