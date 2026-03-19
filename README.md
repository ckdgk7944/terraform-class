# terraform-class

DnDn 데모 환경 인프라 (rapa 계정: 451017115109)

## 리소스
- VPC + Public/Private Subnet + IGW
- EC2 (t3.micro) — 취약한 SG 연결
- S3 버킷 (퍼블릭 접근 허용)
- IAM User (MFA 없음, Admin 권한)
- GuardDuty, IAM Access Analyzer
- Security Hub / AWS Config (기존 활성화)

## CI/CD
- PR 생성 시 `terraform plan` 자동 실행
- `main` 머지 시 `terraform apply` 자동 실행
