variable "name" {
  default = "lainecloud"
}

variable "public_key_path" {
  default = "~/.ssh/lainecloud-vpn.pub"
}

variable "open_vpn_instance_type" {
  default = "t2.micro"
}
