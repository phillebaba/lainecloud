locals {
  domain_components = split(var.domain_name, ".")
  root_domain       = element(local.domain_components, length(local.domain_components) - 1)
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_route53_zone" "main" {
  #name         = "${local.root_domain}."
  name         = "lainecloud.com."
  private_zone = false
}

