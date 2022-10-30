provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "web-server" {
  ami             = "ami-09d3b3274b6c5d4aa"
  instance_type   = "t2.micro"
  count = 2
  key_name        = "firstkey"
  security_groups = ["${aws_security_group.web-server.name}"]
  user_data       = <<-EOF
        
        #!/bin/bash
        sudo su
        yum update -y
        yum install httpd -y
        systemctl start httpd
        systemctl enable httpd
        echo "<html><h1> Welcome to my webserver. Happy Learning from $(hostname -f)..</p> </h1>" > /var/www/html/index.html
        EOF

  tags = {
    Name = "instance-${count.index}"
  }

}