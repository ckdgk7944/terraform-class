variable "project" {
  description = "프로젝트명 접두사"
  type        = string
  default     = "rapa"
}

variable "environment" {
  description = "배포 환경"
  type        = string
  default     = "prod"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "사용할 가용영역"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2c"]
}

variable "public_subnet_cidrs" {
  description = "퍼블릭 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.11.0/24"]
}

variable "private_subnet_cidrs" {
  description = "프라이빗 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.12.0/24"]
}

variable "db_subnet_cidrs" {
  description = "DB 서브넷 CIDR 목록"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.13.0/24"]
}

variable "admin_cidr" {
  description = "관리자 접근 허용 CIDR (Bastion SSH)"
  type        = string
  default     = "0.0.0.0/0"
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t3.micro"
}

variable "db_instance_class" {
  description = "RDS 인스턴스 클래스"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "RDS 데이터베이스명"
  type        = string
  default     = "rapadb"
}

variable "db_username" {
  description = "RDS 마스터 사용자명"
  type        = string
  default     = "admin"
}

variable "alarm_email" {
  description = "알람 수신 이메일"
  type        = string
  default     = ""
}

locals {
  name_prefix = "${var.project}-${var.environment}"

  common_tags = {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "terraform"
    Owner       = "platform-team"
  }
}
