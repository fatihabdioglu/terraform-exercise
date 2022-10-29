
provider "aws" {
    region = "us-east-1"
  
}

resource "aws_security_group" "TF_SG" {
  name        = "allow_tls"
  description = "Allow http-ssh"
  vpc_id      = "vpc-086ec57c6cbfe3009"

  ingress {
    description      = "Thttps"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}



# 1. Create Ubuntu server and install/enable apache2

resource "aws_instance" "web-server-instance" {
    ami = "ami-0ee23bfc74a881de5"
    instance_type = "t2.micro"
    availability_zone = "us-east-1a"
    key_name = "firstkey"
    security_groups = [aws_security_group.TF_SG.name]

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