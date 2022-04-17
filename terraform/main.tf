# --- root/main.tf ---

resource "aws_key_pair" "trobsec_key" {
    key_name = "trobsec-key"
    public_key = file("~/.ssh/${var.aws_key_name}.pub")
}

resource "aws_vpc" "trobsec_vpc" {
    cidr_block = "10.87.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
        Name = "trobsec"
    }
}

resource "aws_subnet" "trobsec_public_subnet" { 
    vpc_id = aws_vpc.trobsec_vpc.id
    cidr_block = "10.87.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "us-west-1a"

    tags = {
        Name = "trobsec-public"
    }
}

resource "aws_route_table" "trobsec_public_rt" {
    vpc_id = aws_vpc.trobsec_vpc.id

    tags = {
        Name = "trobsec-public-rt"
    }
}

resource "aws_internet_gateway" "trobsec_igw" {
    vpc_id = aws_vpc.trobsec_vpc.id

    tags = {
        Name = "trobsec-igw"
    }
}

resource "aws_route" "default_route" {
    route_table_id = aws_route_table.trobsec_public_rt.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.trobsec_igw.id
}

resource "aws_route_table_association" "trobsec_public_association" {
    subnet_id = aws_subnet.trobsec_public_subnet.id
    route_table_id = aws_route_table.trobsec_public_rt.id
}

resource "aws_security_group" "trobsec_sg" {
    name = "trobsec_sg"
    description = "trobsec security group"
    vpc_id = aws_vpc.trobsec_vpc.id

    ingress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [var.my_public_ip]
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

resource "aws_instance" "trobsec_host" {
    instance_type = "t2.micro"
    ami = data.aws_ami.server_ami.id
    key_name = aws_key_pair.trobsec_key.id
    vpc_security_group_ids = [aws_security_group.trobsec_sg.id]
    subnet_id = aws_subnet.trobsec_public_subnet.id
    user_data = file("userdata.tpl")

    root_block_device {
      volume_size = 10
    }

    tags = {
        Name = "trobsec-host"
    }
}