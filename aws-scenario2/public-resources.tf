resource "aws_security_group" "ec2_sg" {
  name = "ec2_sg"
  description = "Security group for public ec2"
  vpc_id = aws_vpc.pub_priv_vpc.id

  # Only SSH from admin ip
  ingress {
    description = "ssh from admin"
    from_port   = "22"
    to_port     = "22"
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  # Allow Https
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [var.ubuntu_account_number]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "public_ec2" {
    ami = data.aws_ami.ubuntu.id
    instance_type = var.instance_type
    subnet_id = aws_subnet.pub_subnet.id
    associate_public_ip_address = var.associate_public_ip_address
    key_name = aws_key_pair._.key_name
    vpc_security_group_ids = [aws_security_group.ec2_sg.id]

    root_block_device {
      volume_size = var.volume_size
    }

    tags = {
      "Name" = var.ec2_name
    }
}

resource "aws_eip" "ec2_eip" {
  vpc = true
  instance = aws_instance.public_ec2.id
}

resource "tls_private_key" "_" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "_" {
  key_name = var.key_name
  public_key = tls_private_key._.public_key_openssh
}

output "private_key" {
  value = tls_private_key._.private_key_pem
}

output "webapp_ip" {
  value = aws_instance.public_ec2.public_ip
}