
provider "aws" {
    region = "us-east-1"
  
}


# 1. Create vpc

resource "aws_vpc" "tf-project" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tfprojeeesi"
  }
}

# 2. Create Internet Gateway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.tf-project.id

}

# 3. Create Custom Route Table

resource "aws_route_table" "tf-route-table" {
  vpc_id = aws_vpc.tf-project.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "tfproje"
  }
}

# 4. Create a Subnet

resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.tf-project.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "tf-subnet"
    }
  
}

# 5. Associate subnet with Route Table

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.tf-route-table.id
}

# 6. Create Sec.Group to allow port 22,80,443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web inbound traffic"
  vpc_id      = aws_vpc.tf-project.id

  ingress {
    description      = "Https"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "Http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_web"
  }
}

# 7. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
    ami = "ami-0ee23bfc74a881de5"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "firstkey"


    user_data = <<-EOF
                #!/bin/bash
                sudo apt update -y
                sudo apt install apache2 -y
                sudo systemctl start apache2
                cd / && cd /var/www/html
                sudo echo " <h1> Merhaba ben Fatih.Bu bir terraform web server denemesidir. </h1> " > index.html
                EOF
    tags = {
        Name = "apache-server"
    }
}

output "aws_instance_ip" {
    value = aws_instance.web-server-instance.public_ip
  
}