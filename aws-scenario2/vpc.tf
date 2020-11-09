resource "aws_vpc" "pub_priv_vpc" {
    cidr_block = var.vpc_cidr 
    tags = {
        Name = "pub_priv_vpc"
    }
}

data "aws_availability_zones" "available" {
    state = "available"
}

/*
* Public Subnet
*/
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.pub_priv_vpc.id
    tags = {
        Name = "igw"
    }
}

resource "aws_route_table" "rt_pub" {
    vpc_id = aws_vpc.pub_priv_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }

    tags = {
        Name = "rt_pub"
    }
}

resource "aws_subnet" "pub_subnet" {
    vpc_id = aws_vpc.pub_priv_vpc.id
    cidr_block = var.pub_subnet_cidr
    map_public_ip_on_launch=true
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "pub_subnet"
    }
}

/*
* Private Subnet
*/
resource "aws_subnet" "priv_subnet1" {
    vpc_id = aws_vpc.pub_priv_vpc.id
    cidr_block = var.priv_subnet_cidr1
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "priv_subnet1"
    }
}


resource "aws_subnet" "priv_subnet2" {
    vpc_id = aws_vpc.pub_priv_vpc.id
    cidr_block = var.priv_subnet_cidr2
    availability_zone = data.aws_availability_zones.available.names[1]

    tags = {
        Name = "priv_subnet2"
    }
}

resource "aws_route_table_association" "pub_association" {
  subnet_id = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.rt_pub.id
}

resource "aws_eip" "nat_eip" {
    vpc = true

    tags = {
        Name = "nat_eip"
    }
}

resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.nat_eip.id
    subnet_id = aws_subnet.pub_subnet.id

    tags = {
        Name = "gw NAT"
    }
}

resource "aws_route_table" "rt_priv" {
    vpc_id = aws_vpc.pub_priv_vpc.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.ngw.id
    }

    tags = {
        Name = "rt_priv"
    }
}

resource "aws_route_table_association" "priv_association1" {
  subnet_id = aws_subnet.priv_subnet1.id
  route_table_id = aws_route_table.rt_priv.id
}

resource "aws_route_table_association" "priv_association2" {
  subnet_id = aws_subnet.priv_subnet2.id
  route_table_id = aws_route_table.rt_priv.id
}

resource "aws_network_acl" "nacl" {
    vpc_id = aws_vpc.pub_priv_vpc.id
    subnet_ids = [aws_subnet.pub_subnet.id, aws_subnet.priv_subnet1.id, aws_subnet.priv_subnet2.id]

    ingress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }

    egress {
        protocol   = -1
        rule_no    = 100
        action     = "allow"
        cidr_block = "0.0.0.0/0"
        from_port  = 0
        to_port    = 0
    }

    tags = {
        Name = "nacl"
    }
}