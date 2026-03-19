variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "허용된 CIDR 블록 리스트"
  type        = list(string)
  validation {
    condition     = !contains(var.allowed_cidr_blocks, "0.0.0.0/0")
    error_message = "CIDR block 0.0.0.0/0 is not allowed."
  }
}

variable "environment" {
  description = "환경 (예: prod, dev, stage)"
  type        = string
  default     = "prod"
}
