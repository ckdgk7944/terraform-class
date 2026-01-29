# 라우팅 테이블
resource "aws_route_table" "vec_prd_pub_rt" {
  vpc_id = aws_vpc.vec_prd_vpc.id

  tags = {
    "Name" = "VEC-PRD-RT-PUB"
  }
}

resource "aws_route_table" "vec_prd_pri_rt" {
  vpc_id = aws_vpc.vec_prd_vpc.id

  tags = {
    "Name" = "VEC-PRD-RT-PRI"
  }
}

# 라우팅
resource "aws_route" "vec_prd_pub_route" {
  route_table_id         = aws_route_table.vec_prd_pub_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vec_prd_igw.id
}

resource "aws_route" "vec_prd_pri_route" {
  route_table_id         = aws_route_table.vec_prd_pri_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.vec_prd_ngw_2a.id
}

# 명시적 서브넷 연결
resource "aws_route_table_association" "vec_prd_bst_rt_associate_2a" {
  subnet_id      = aws_subnet.vec_prd_bst_subnet_2a.id
  route_table_id = aws_route_table.vec_prd_pub_rt.id
}

resource "aws_route_table_association" "vec_prd_pub_rt_associate_2a" {
  subnet_id      = aws_subnet.vec_prd_pub_subnet_2a.id
  route_table_id = aws_route_table.vec_prd_pub_rt.id
}

resource "aws_route_table_association" "vec_prd_pub_rt_associate_2c" {
  subnet_id      = aws_subnet.vec_prd_pub_subnet_2c.id
  route_table_id = aws_route_table.vec_prd_pub_rt.id
}

resource "aws_route_table_association" "vec_prd_pri_rt_associate_2a" {
  subnet_id      = aws_subnet.vec_prd_pri_subnet_2a.id
  route_table_id = aws_route_table.vec_prd_pri_rt.id
}

resource "aws_route_table_association" "vec_prd_pri_rt_associate_2c" {
  subnet_id      = aws_subnet.vec_prd_pri_subnet_2c.id
  route_table_id = aws_route_table.vec_prd_pri_rt.id
}