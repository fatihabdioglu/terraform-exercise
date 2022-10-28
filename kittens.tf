provider "aws" {
    region = "us-east-1"
  
}



resource "aws_instance" "web" {
  ami           = "ami-09d3b3274b6c5d4aa"
  instance_type = "t2.micro"
  key_name = "firstkey"
  availability_zone = "us-east-1a"

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              sudo chmod -R 777 /var/www/html
              cd /var/www/html
              wget https://raw.githubusercontent.com/fatihabdioglu/my-projects/main/Project-101-kittens-carousel-static-website-ec2/static-web/index.html
              wget https://raw.githubusercontent.com/fatihabdioglu/my-projects/main/Project-101-kittens-carousel-static-website-ec2/static-web/cat0.jpg
              wget https://raw.githubusercontent.com/fatihabdioglu/my-projects/main/Project-101-kittens-carousel-static-website-ec2/static-web/cat1.jpg
              wget https://raw.githubusercontent.com/fatihabdioglu/my-projects/main/Project-101-kittens-carousel-static-website-ec2/static-web/cat2.jpg
              wget https://raw.githubusercontent.com/fatihabdioglu/my-projects/main/Project-101-kittens-carousel-static-website-ec2/static-web/cat3.png
              EOF

  tags = {
    Name = "kittens"
  }
}