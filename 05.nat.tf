# 탄력적 IP
resource "aws_eip" "vec_prd_nat_eip" {
  domain = "vpc"
  tags = {
    "Name" = "VEC-PRD-NAT-EIP"
  }
}

# NAT 게이트웨이
resource "aws_nat_gateway" "vec_prd_ngw_2a" {
  allocation_id = aws_eip.vec_prd_nat_eip.id
  subnet_id     = aws_subnet.vec_prd_pub_subnet_2a.id
  tags = {
    "Name" = "VEC-PRD-NAT-2A"
  }
}