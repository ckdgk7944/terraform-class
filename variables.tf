# 기존 변수 유지

variable "ssm_patch_baseline_operating_system" {
  description = "운영체제 타입"
  type        = string
  default     = "AMAZON_LINUX_2"
}

variable "ssm_patch_group_name" {
  description = "패치 그룹 이름"
  type        = string
  default     = "production-patches"
}
