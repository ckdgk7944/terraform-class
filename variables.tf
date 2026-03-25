variable "project" {
  description = "Project name"
  type        = string
  default     = "dndn-demo"
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "required_tags" {
  description = "Required tags for all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Team        = "platform"
    Service     = "demo"
  }
}