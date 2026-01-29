resource "aws_vpc" "vec_prd_vpc" {
  cidr_block           = "10.250.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "VEC-PRD-VPC"
  }
}