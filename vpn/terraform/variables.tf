variable "name" {
  description = "Name of the deployment."
  default = "lainecloud"
}

variable "cidr_block" {
  description = "CIDR to use for the create VPC."
  default = "10.0.2.192/26"
}

variable "vpn_instance_type" {
  description = "Instance type used for the OpenVPN instance."
  default = "t2.micro"
}

variable "public_key_path" {
  default = "~/.ssh/lainecloud-vpn.pub"
}
