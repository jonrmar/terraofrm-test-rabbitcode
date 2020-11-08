#VPC
variable "region" {
    default = "us-east-1"
    description = "AWS region"
}

variable "vpc_cidr" {
    default = "10.0.0.0/16"
    description = "VPC cidr block"
}

variable "pub_subnet_cidr" {
    default = "10.0.1.0/24"
    description = " Public subnet cidr block"
}

variable "priv_subnet_cidr" {
    default = "10.0.1.0/24"
    description = " Private subnet cidr block"
}

#RDS
variable "port" {
    default = 5432
    description = "RDS port"
}

variable "db_storage" {
    default = 20
    description = "RDS storage"
}

variable "db_storage_type" {
    default = "gp2"
    description = "RDS storage type"
}

variable "engine" {
    default = "postgresql"
    description = "RDS engine"
}

variable "engine_version" {
    default = "10"
    description = "RDS engine version"
}

variable "instance_class" {
    default = "db.t2.micro"
    description = "RDS instance class"
}

variable "deletion_protection" {
    default = true
    description = "RDS deletion protection flag"
}

variable "db_username" {
    default = ""
    description = "RDS master username"
}

variable "db_pass" {
    default = ""
    description = "RDS master password"
}

#EC2
variable "ec2_name" {
    default = "webapp"
    description = "EC2 name"
}

variable "instance_type" {
    default = "t2_micro"
    description = "EC2 instance type"
}

variable "associate_public_ip_address" {
    default = true
    description = "EC2 associate public ip address"
}

variable "key_name" {
    default = "ec2_key"
    description = "EC2 key name"
}

variable "my_ip" {
    default = ""
    description = "EC2 ssh sg rule"
}

variable "ami" {
    default = ""
    description = "EC2 ami"
}