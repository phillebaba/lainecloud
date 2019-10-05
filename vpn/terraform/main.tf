provider "aws" {
  region = "eu-west-1"
}

# VPC
module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v2.7.0"

  name           = var.name
  azs            = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  cidr           = "10.0.0.0/16"
  public_subnets = ["10.0.0.0/22"]
}

# EC2
resource "aws_key_pair" "open_vpn" {
  key_name   = "${var.name}-key-pair"
  public_key = file(var.public_key_path)
}

resource "aws_security_group" "open_vpn" {
  name   = "${var.name}-vpn-sg"
  vpc_id = module.vpc.vpc_id

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
}

resource "aws_instance" "open_vpn" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.open_vpn_instance_type
  subnet_id              = module.vpc.public_subnets.0
  key_name               = aws_key_pair.open_vpn.key_name
  vpc_security_group_ids = [aws_security_group.open_vpn.id]

  tags = {
    Name = "${var.name}-vpn"
  }
}

# Route53
resource "aws_route53_record" "kube-ops-view" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "kube-ops-view.lainecloud.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.open_vpn.public_ip]
}

resource "aws_route53_record" "argocd" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "argocd.lainecloud.com"
  type    = "A"
  ttl     = "300"
  records = [aws_instance.open_vpn.public_ip]
}

# Ansible
resource "null_resource" "ansible" {
  provisioner "local-exec" {
    command = <<EOF
    echo "Sleeping for 60 seconds"
    sleep 60
    echo "Starting ansible playbook"
    export ANSIBLE_HOST_KEY_CHECKING=false
    ansible-playbook -u ec2-user -i '${aws_instance.open_vpn.public_ip},' ../ansible/playbook.yml
    EOF
  }
}
