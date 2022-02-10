variable "ami_id" {
    description = "Ec2 ami id"
    type = string
}

variable "instance_type" {
    description = "Ec2 instance type"
    type = string
    default = "t3.micro"
}

variable "subnet_id" {
    description = "Ec2 subnet"
    type = string
}

variable "associate_public_ip_address" {
    description = "Elastic IP"
    type = string
}

variable "key_name" {
    description = "ssh key"
    type = string
}

variable "sg_ids" {
    description = "Security groups ids"
    type = list(string)
}

variable "volume_size" {
    description = "Storage size"
    type = string
}

variable "ec2_name" {
    description = "Ec2 name"
    type = string
}