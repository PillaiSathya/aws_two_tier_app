resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags       = { Name = "sathya-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet_cidr
  map_public_ip_on_launch = true
  tags                    = { Name = "sathya-public-subnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "sathya-igw" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = { Name = "sathya-public-rt" }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "web_sg" {
  name        = "sathya-web-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow SSH and HTTP"

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_allowed_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "sathya-web-sg" }
}

# get latest Amazon Linux 2 AMI (ap-south-1)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.amazon_linux.id # use your data.aws_ami.amazon_linux.id if you want
  instance_type          = "t2.micro"
  key_name               = "terraform-key-mumbai"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              amazon-linux-extras install -y nginx1
              systemctl enable nginx
              systemctl start nginx
              echo "<h1>Hello from Sathya - Terraform provisioned Nginx</h1>" > /usr/share/nginx/html/index.html
              EOF

  tags = {
    Name = "sathya-web-instance"
  }
}

# Two private subnets (different AZs)
resource "aws_subnet" "private1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet1_cidr
  map_public_ip_on_launch = false
  availability_zone       = "ap-south-1a"
  tags                    = { Name = "sathya-private-subnet-1" }
}

resource "aws_subnet" "private2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.private_subnet2_cidr
  map_public_ip_on_launch = false
  availability_zone       = "ap-south-1b"
  tags                    = { Name = "sathya-private-subnet-2" }
}

# RDS SG (no public access)
resource "aws_security_group" "rds_sg" {
  name        = "sathya-rds-sg"
  vpc_id      = aws_vpc.main.id
  description = "Allow MySQL from web SG only"
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = { Name = "sathya-rds-sg" }
}

# Ingress rule: allow MySQL from the web server's SG
resource "aws_security_group_rule" "rds_from_web" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  security_group_id        = aws_security_group.rds_sg.id
  source_security_group_id = aws_security_group.web_sg.id
}

# RDS must live in a subnet group with at least two subnets (different AZs)
resource "aws_db_subnet_group" "rds_subnets" {
  name       = "sathya-rds-subnet-group"
  subnet_ids = [aws_subnet.private1.id, aws_subnet.private2.id]
  tags       = { Name = "sathya-rds-subnet-group" }
}

resource "aws_db_instance" "mysql" {
  identifier              = "sathya-mysql"
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro" # Free tier eligible
  allocated_storage       = 20            # Free tier
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  db_subnet_group_name    = aws_db_subnet_group.rds_subnets.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]
  publicly_accessible     = false
  multi_az                = false
  storage_encrypted       = false
  backup_retention_period = 0
  deletion_protection     = false
  skip_final_snapshot     = true

  tags = { Name = "sathya-mysql" }
}

