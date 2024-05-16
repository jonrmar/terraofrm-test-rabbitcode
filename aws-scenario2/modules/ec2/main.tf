resource "aws_instance" "ec2" {
    ami = var.ami_id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    associate_public_ip_address = var.associate_public_ip_address
    key_name = var.key_name
    vpc_security_group_ids = var.sg_ids

    root_block_device {
      volume_size = var.volume_size
    }

    tags = {
      "Name" = var.ec2_name
    }
}