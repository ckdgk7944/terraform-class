# ── IAM User with MFA and Least Privilege ──
resource "aws_iam_user" "demo" {
  name = "${var.project}-user"
  force_destroy = true
  tags = {
    Name = "${var.project}-user"
    Environment = "demo"
    Team = "security"
    Service = "iam"
  }
}

resource "aws_iam_user_policy" "demo_s3_access" {
  name = "s3-specific-access"
  user = aws_iam_user.demo.name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::${var.project}-bucket",
        "arn:aws:s3:::${var.project}-bucket/*"
      ]
    }]
  })
}

resource "aws_iam_user_login_profile" "demo" {
  user = aws_iam_user.demo.name
  password_reset_required = true
}

resource "aws_iam_user_mfa" "demo" {
  user_name = aws_iam_user.demo.name
  virtual_mfa_device_name = "${var.project}-mfa"
}

resource "aws_iam_role" "demo" {
  name = "${var.project}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
  permissions_boundary = aws_iam_policy.permissions_boundary.arn
  tags = {
    Environment = "demo"
    Team = "security"
    Service = "iam"
  }
}

resource "aws_iam_policy" "permissions_boundary" {
  name = "${var.project}-permissions-boundary"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:PutObject",
        "s3:ListBucket"
      ]
      Resource = "*"
    }]
  })
}
