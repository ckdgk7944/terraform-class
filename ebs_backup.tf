# AWS Backup vault 생성
resource "aws_backup_vault" "ebs" {
  name = "${var.project}-ebs-backup-vault"
  tags = merge(
    { Name = "${var.project}-ebs-backup-vault" },
    var.required_tags
  )
}

# AWS Backup plan 생성
resource "aws_backup_plan" "ebs" {
  name = "${var.project}-ebs-backup-plan"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.ebs.name
    schedule          = "cron(0 1 ? * * *)"

    lifecycle {
      delete_after = 30
    }
  }

  tags = merge(
    { Name = "${var.project}-ebs-backup-plan" },
    var.required_tags
  )
}

# Backup IAM Role 생성
resource "aws_iam_role" "backup" {
  name = "${var.project}-backup-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "backup.amazonaws.com"
      }
    }]
  })

  tags = merge(
    { Name = "${var.project}-backup-role" },
    var.required_tags
  )
}

resource "aws_iam_role_policy_attachment" "backup" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.backup.name
}

# Selection 생성 - 모든 EBS 볼륨 포함
resource "aws_backup_selection" "ebs" {
  iam_role_arn = aws_iam_role.backup.arn
  name         = "${var.project}-ebs-backup-selection"
  plan_id      = aws_backup_plan.ebs.id

  selection_tag {
    type  = "STRINGEQUALS"
    key   = "Environment"
    value = "development"
  }
}
