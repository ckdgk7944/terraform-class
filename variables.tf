variable "project" {
  description = "Project name"
  type        = string
  default     = "dndn-demo"
}

variable "pgp_key" {
  description = "PGP key for IAM user password encryption"
  type        = string
}

variable "mandatory_tags" {
  description = "Mandatory tags for all resources"
  type        = map(string)
  default     = {
    Environment = "production"
    Team        = "security"
    Service     = "demo"
  }
}
