# --- root/outputs.tf ---

output "public_ip_addr" {
    value = aws_instance.trobsec_host.public_ip
}