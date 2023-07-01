provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["C:\\Users\\Kapil\\.aws\\credentials"]
}


# 6. Security Group
resource "aws_security_group" "allow_web" {
  name        = "allow jenkins"
  description = "Allow web traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "All ICMP"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    # cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "minikube"
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 82
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "tomcat"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "tomcat"
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow-web_terraform"
  }
}




