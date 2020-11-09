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

variable "priv_subnet_cidr1" {
    default = "10.0.2.0/24"
    description = " Private subnet cidr block 1"
}

variable "priv_subnet_cidr2" {
    default = "10.0.3.0/24"
    description = " Private subnet cidr block 2"
}

#RDS
variable "db_name" {
    default = "mydb"
    description = "RDS db name" 
}

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
    default = "postgres"
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

variable "multi_az" {
    default = false
    description = "RDS multi az flag"
}

#EC2
variable "ec2_name" {
    default = "webapp"
    description = "EC2 name"
}

variable "instance_type" {
    default = "t2.micro"
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
    default = "ami-07efac79022b86107"
    description = "EC2 ami"
}

variable "volume_size" {
    default = "8"
    description = "EC2 ebs size"
}

variable "ubuntu_account_number" {
  default = "099720109477"
}