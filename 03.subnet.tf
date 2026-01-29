# Public Subnet
resource "aws_subnet" "vec_prd_bst_subnet_2a" {
  vpc_id                  = aws_vpc.vec_prd_vpc.id
  cidr_block              = "10.250.4.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    "Name"                                         = "VEC-PRD-VPC-BESTION-PUB-2A"
    "kubernetes.io/role/elb"                       = "1"
    "kubernetes.io/cluster/terraform-eks-cluster"  = "shared"
  }
}

resource "aws_subnet" "vec_prd_pub_subnet_2a" {
  vpc_id                  = aws_vpc.vec_prd_vpc.id
  cidr_block              = "10.250.1.0/24"
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = true
  tags = {
    "Name"                                         = "VEC-PRD-VPC-NGINX-PUB-2A"
    "kubernetes.io/role/elb"                       = "1"
    "kubernetes.io/cluster/terraform-eks-cluster"  = "shared"
  }
}

resource "aws_subnet" "vec_prd_pub_subnet_2c" {
  vpc_id                  = aws_vpc.vec_prd_vpc.id
  cidr_block              = "10.250.11.0/24"
  availability_zone       = "ap-northeast-2c"
  map_public_ip_on_launch = true
  tags = {
    "Name"                                         = "VEC-PRD-VPC-NGINX-PUB-2C"
    "kubernetes.io/role/elb"                       = "1"
    "kubernetes.io/cluster/terraform-eks-cluster"  = "shared"
  }
}

# Private Subnet
resource "aws_subnet" "vec_prd_pri_subnet_2a" {
  vpc_id            = aws_vpc.vec_prd_vpc.id
  cidr_block        = "10.250.2.0/24"
  availability_zone = "ap-northeast-2a"
  tags = {
    "Name"                                         = "VEC-PRD-VPC-TOMCAT-PRI-2A"
    "kubernetes.io/role/internal-elb"              = "1"
    "kubernetes.io/cluster/terraform-eks-cluster"  = "shared"
  }
}

resource "aws_subnet" "vec_prd_pri_subnet_2c" {
  vpc_id            = aws_vpc.vec_prd_vpc.id
  cidr_block        = "10.250.12.0/24"
  availability_zone = "ap-northeast-2c"
  tags = {
    "Name"                                         = "VEC-PRD-VPC-TOMCAT-PRI-2C"
    "kubernetes.io/role/internal-elb"              = "1"
    "kubernetes.io/cluster/terraform-eks-cluster"  = "shared"
  }
}