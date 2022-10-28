provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "my-first-server" {
  ami           = var.ec2_ami
  instance_type = var.instance_type
  key_name      = var.key_name

  user_data = var.user_data

  tags = {
    Name = "fatih-ubuntu-server"
    }
}







