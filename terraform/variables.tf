# --- root/variables.tf ---

variable "aws_profile" {
    type = string
    description = "AWS Profile"
}

variable "aws_key_name" {
    type = string
    description = "AWS Key"
}

variable "my_public_ip" {
    type = string
    description = "My public IP address + CIDR"
}