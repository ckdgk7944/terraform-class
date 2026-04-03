# ── NAT Instance SG ─────────────────────────────────────────────────────────
resource "aws_security_group" "nat" {
  name        = "${local.name_prefix}-nat-sg"
  description = "NAT Instance - private subnet outbound"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "${local.name_prefix}-nat-sg" })

  ingress {
    description = "All from private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidrs
  }

  ingress {
    description = "All from DB subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.db_subnet_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ── Bastion SG ──────────────────────────────────────────────────────────────
resource "aws_security_group" "bastion" {
  name        = "${local.name_prefix}-bastion-sg"
  description = "Bastion host - SSH from admin CIDR"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "${local.name_prefix}-bastion-sg" })

  ingress {
    description = "SSH from admin"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.admin_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ── ALB SG ──────────────────────────────────────────────────────────────────
resource "aws_security_group" "alb" {
  name        = "${local.name_prefix}-alb-sg"
  description = "Application Load Balancer"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "${local.name_prefix}-alb-sg" })

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ── Web Server SG ──────────────────────────────────────────────────────────
resource "aws_security_group" "web" {
  name        = "${local.name_prefix}-web-sg"
  description = "Web servers - HTTP from ALB, SSH from Bastion"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "${local.name_prefix}-web-sg" })

  ingress {
    description     = "HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ── App Server SG ──────────────────────────────────────────────────────────
resource "aws_security_group" "app" {
  name        = "${local.name_prefix}-app-sg"
  description = "App servers - API from Web, SSH from Bastion"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "${local.name_prefix}-app-sg" })

  ingress {
    description     = "API from Web tier"
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.web.id]
  }

  ingress {
    description     = "SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ── Database SG ─────────────────────────────────────────────────────────────
resource "aws_security_group" "db" {
  name        = "${local.name_prefix}-db-sg"
  description = "RDS MySQL - access from App tier only"
  vpc_id      = aws_vpc.main.id
  tags        = merge(local.common_tags, { Name = "${local.name_prefix}-db-sg" })

  ingress {
    description     = "MySQL from App tier"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app.id]
  }

  ingress {
    description     = "MySQL from Bastion (DB 관리)"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
