terraform {
  required_version = ">=0.13.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.22.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "3.0.0"
    }
    pass = {
      source  = "camptocamp/pass"
      version = "1.4.0"
    }
    null = {
      source = "hashicorp/null"
       version = "3.0.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "pass" {
}

locals {
  fqdn = "lainecloud.com"
  subnets = cidrsubnets(var.cidr_block, 2, 2, 2)
}

# VPC
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block

  tags = {
    Name = var.name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = var.name
  }
}

resource "aws_default_route_table" "main" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main.id
  }

  tags = {
    Name = var.name
  }
}

resource "aws_subnet" "main" {
  count = length(local.subnets)

  vpc_id     = aws_vpc.main.id
  cidr_block = local.subnets[count.index]
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = var.name
  }
}

# EC2
data "aws_ami" "amazon_linux_2" {
  most_recent = false
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20200406.0-x86_64-gp2"]
  }
}

data "pass_password" "main" {
  path = "laine-cloud/ssh/vpn"
}

data "tls_public_key" "main" {
  private_key_pem = base64decode(data.pass_password.main.password)
}

resource "aws_key_pair" "ssh" {
  key_name   = "${var.name}-ssh"
  public_key = data.tls_public_key.main.public_key_openssh
}

resource "aws_security_group" "vpn" {
  name   = "${var.name}-vpn-sg"
  vpc_id = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 1194
    to_port     = 1194
    protocol    = "UDP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = var.name
  }
}

resource "aws_instance" "vpn" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.vpn_instance_type
  subnet_id              = aws_subnet.main.0.id
  key_name               = aws_key_pair.ssh.key_name
  vpc_security_group_ids = [aws_security_group.vpn.id]

  tags = {
    Name = var.name
  }
}

# Route53
data "aws_route53_zone" "main" {
  name         = "${local.fqdn}."
  private_zone = false
}

resource "aws_route53_record" "vpn" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "vpn.${local.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.vpn.public_ip]
}

resource "aws_route53_record" "wildcard" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "*.${local.fqdn}"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.vpn.public_ip]
}
