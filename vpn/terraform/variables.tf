variable "name" {
  default = "lainecloud"
}

variable "public_key_path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "open_vpn_instance_type" {
  default = "t2.micro"
}

variable "domain_name" {
  description = "Domain name to direct to client"
}
