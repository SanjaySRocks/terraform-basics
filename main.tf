
resource "aws_instance" "web" {
  ami           = "ami-053b0d53c279acc90" #ubuntu
  instance_type = "t2.micro"

  tags = {
    Name = "HelloWorld"
  }
}