provider "aws" {
  region = "us-east-1"  
}

# Create a security group to allow SSH access
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Warning: This allows SSH from any IP!
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Launch the EC2 instance
resource "aws_instance" "my_ec2" {
  ami           = "ami-00a929b66ed6e0de6"  # Amazon Linux 2 AMI (us-east-1)
  instance_type = "t2.micro"               # Free tier eligible
  
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  
  tags = {
    Name = "My-First-EC2"
  }
}

# Output the public IP address
output "public_ip" {
  value = aws_instance.my_ec2.public_ip
}
