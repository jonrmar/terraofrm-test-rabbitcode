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
* Subnet Publica
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

resource "aws_subnet" "priv_subnet" {
    vpc_id = aws_vpc.pub_priv_vpc.id
    cidr_block = var.priv_subnet_cidr
    availability_zone = data.aws_availability_zones.available.names[0]

    tags = {
        Name = "priv_subnet"
    }
}

resource "aws_route_table_association" "pub_association" {
  subnet_id = aws_subnet.pub_subnet.id
  route_table_id = aws_route_table.rt_pub.id
}

/*
* Subnet Privada
*/
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

resource "aws_route_table_association" "priv_association" {
  subnet_id = aws_subnet.priv_subnet.id
  route_table_id = aws_route_table.rt_priv.id
}


resource "aws_network_acl" "nacl" {
    vpc_id = aws_vpc.pub_priv_vpc.id
    subnet_ids = [aws_subnet.pub_subnet.id, aws_subnet.priv_subnet.id]

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