
resource "aws_key_pair" "web_key" {
  key_name   = "web-key"
  public_key = file("~/.ssh/id_rsa.pub") # Path to your local public SSH key
}

resource "aws_instance" "web" {
  ami           = "ami-0866a3c8686eaeeba" #ubuntu 24.04 LTS us-east1
  instance_type = "t2.micro"

  key_name = aws_key_pair.web_key.key_name # Associate the SSH key

  user_data = file("startup.sh")

  vpc_security_group_ids = [aws_security_group.allow_common_ports.id]

  tags = {
    Name = "HelloWorld"
  }
}


resource "aws_security_group" "allow_common_ports" {
  # Create firewall open ports
  name        = "allow-common-ports"
  description = "Security group to allow common ports including 3128"

  # Allow incoming traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust to restrict SSH access
    description = "Allow SSH access"
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP traffic"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS traffic"
  }

  ingress {
    from_port   = 3128
    to_port     = 3128
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow Proxy traffic on port 3128"
  }

  # Allow all outbound traffic (default behavior)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow-common-ports"
  }
}


resource "aws_eip" "web_static_ip" {
  # Create Static IP
  instance = aws_instance.web.id

  tags = {
    Name = "WebStaticIP"
  }
}
