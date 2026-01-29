resource "aws_internet_gateway" "vec_prd_igw" {
  vpc_id = aws_vpc.vec_prd_vpc.id
  tags = {
    "Name" = "VEC-PRD-IGW"
  }
}