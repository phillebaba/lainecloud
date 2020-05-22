output "vpn_public_ip" {
  value = aws_instance.vpn.public_ip
}

output "private_key_pem" {
  value = base64decode(data.pass_password.main.password)
  sensitive = true
}
