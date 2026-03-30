# ── VPC ──
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(
    { Name = "${var.project}-vpc" },
    var.required_tags
  )
}

# ── Subnets ──
resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = "ap-northeast-2a"
  map_public_ip_on_launch = false  # EC2.15 보안 요구사항 준수
  tags = merge(
    { Name = "${var.project}-subnet-a" },
    var.required_tags
  )
}

resource "aws_subnet" "private_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = "ap-northeast-2b"
  tags = merge(
    { Name = "${var.project}-subnet-b" },
    var.required_tags
  )
}

# ── Internet Gateway ──
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { Name = "${var.project}-igw" },
    var.required_tags
  )
}

# ── Route Table (Public) ──
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    { Name = "${var.project}-public-rt" },
    var.required_tags
  )
}

resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

# ── VPC Flow Logs ──
resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.flow_log.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
  tags = merge(
    { Name = "${var.project}-flow-log" },
    var.required_tags
  )
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name              = "/aws/vpc/flow-log/${var.project}"
  retention_in_days = 30
  tags = merge(
    { Name = "${var.project}-flow-log" },
    var.required_tags
  )
}

resource "aws_iam_role" "flow_log" {
  name = "${var.project}-flow-log"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
  })
  tags = merge(
    { Name = "${var.project}-flow-log-role" },
    var.required_tags
  )
}

resource "aws_iam_role_policy" "flow_log" {
  name = "${var.project}-flow-log"
  role = aws_iam_role.flow_log.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ]
      Resource = "${aws_cloudwatch_log_group.flow_log.arn}:*"
    }]
  })
}
