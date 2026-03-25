# IAM User with MFA enforcement
resource "aws_iam_user" "rafa" {
  name = "RAFA_1"
  force_mfa = true
  
  tags = {
    Name = "RAFA_1"
    Environment = "Production"
    Team = "Security"
    Service = "IAM"
  }
}

resource "aws_iam_user_policy" "rafa_restricted" {
  name = "restricted-s3-access"
  user = aws_iam_user.rafa.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "s3:GetObject",
        "s3:ListBucket"
      ]
      Resource = [
        "arn:aws:s3:::specific-bucket",
        "arn:aws:s3:::specific-bucket/*"
      ]
    }]
  })
}

resource "aws_iam_user_login_profile" "rafa" {
  user                    = aws_iam_user.rafa.name
  password_reset_required = true
  pgp_key                = "keybase:username"
}

resource "aws_iam_policy" "require_mfa" {
  name        = "RequireMFA"
  path        = "/"
  description = "Requires MFA for all actions"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Deny"
        NotAction = [
          "iam:CreateVirtualMFADevice",
          "iam:EnableMFADevice",
          "iam:GetUser",
          "iam:ListMFADevices",
          "iam:ListVirtualMFADevices",
          "iam:ResyncMFADevice"
        ]
        Resource = "*"
        Condition = {
          BoolIfExists = {
            "aws:MultiFactorAuthPresent": "false"
          }
        }
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "rafa_mfa" {
  user       = aws_iam_user.rafa.name
  policy_arn = aws_iam_policy.require_mfa.arn
}

resource "aws_iam_user_policy_attachment" "rafa_boundary" {
  user       = aws_iam_user.rafa.name
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}