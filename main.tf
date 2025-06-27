#Ec2 instance creation

/*resource "aws_instance" "dummy" {
    ami="ami-09e6f87a47903347c"
    instance_type = "t2.micro"
  
}*/
resource "aws_instance" "demoServer" {
    ami=var.ami_value
    instance_type = var.instance_type
    vpc_security_group_ids = [aws_security_group.demoSecuritygroup.id]
    subnet_id = aws_subnet.publicSubnet.id
    key_name = "devi_key"
    associate_public_ip_address = true
    availability_zone = "us-east-1a"
}


#Main VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
    //cidr_block = var.cidr_block_value
 
}

# AWS subnet
resource "aws_subnet" "publicSubnet" {
    vpc_id = aws_vpc.main.id
    //availability_zone = "us-east_1a"
    availability_zone = var.availability_zone_value
    cidr_block = "10.0.1.0/24"
     tags = {
    Name = "Main"
  }

}

# internet gate way

resource "aws_internet_gateway" "demo-igw" {
    vpc_id = aws_vpc.main.id
   tags = {
    Name = "DEMOIGW"
  }

}

#route table 

resource "aws_route_table" "demo-rtb" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id

  }
   tags = {
    Name = "DEMORTB"
  }
}

resource "aws_route_table_association" "demoAssociation" {
  subnet_id      = aws_subnet.publicSubnet.id
  route_table_id = aws_route_table.demo-rtb.id
}

#security group

resource "aws_security_group" "demoSecuritygroup" {
    name = "demoSecuritygroup"
    vpc_id = aws_vpc.main.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
   ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

#ec2 instnace key pair

resource "aws_key_pair" "keypair" {
   // key_name = "devi_key"
    public_key = var.aws_key_pair_value
  
}