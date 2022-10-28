output "server_public_ip" {
  value = aws_instance.my-first-server.public_ip
  
}

variable "ec2_ami" {
    default = "ami-08c40ec9ead489470"  # ubuntu 22.04
    description = "ubuntu 22.04 ami"
  
}

variable "instance_type" {
    default = "t2.micro"
  
}

variable "key_name" {
    default = "firstkey"
  
}

variable "user_data" {
    default = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y apache2
              sudo systemctl start apache2
              sudo systemctl enable apache2
              echo "Merhaba bu yazi fatih tarafindan terraform ile yazildi" | sudo tee /var/www/html/index.html
              EOF
  
}