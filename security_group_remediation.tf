resource "aws_security_group" "demo_restricted" {
  name        = "${var.project}-restricted-sg"
  description = "Demo SG - restricted based on security requirements"
  vpc_id      = aws_vpc.main.id
  tags        = merge(
    { Name = "${var.project}-restricted-sg" },
    var.required_tags
  )

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
    description = "SSH restricted to internal networks"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/8", "172.16.0.0/12"]
    description = "Outbound restricted to internal networks"
  }
}

resource "aws_instance" "demo_secure" {
  ami           = "ami-0ecfdfd1c8ae01aec"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.demo_restricted.id]
  associate_public_ip_address = false

  root_block_device {
    volume_size = 8
    volume_type = "gp3"
    encrypted   = true
    kms_key_id  = aws_kms_key.ebs.arn
  }

  tags = merge(
    { Name = "${var.project}-secure" },
    var.required_tags
  )
}

resource "aws_kms_key" "ebs" {
  description             = "KMS key for EBS encryption"
  deletion_window_in_days = 7
  enable_key_rotation    = true

  tags = merge(
    { Name = "${var.project}-ebs-key" },
    var.required_tags
  )
}