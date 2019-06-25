terraform {
  backend "s3" {
    bucket = "terraform-remote-state-1553720878"
    key    = "lainecloud/vpn/terraform.tfstate"
    region = "eu-west-1"
  }
}
