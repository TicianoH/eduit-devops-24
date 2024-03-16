resource "aws_security_group" "example" {
  name = "my-test-sg"

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "tcp"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "myec2" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name      = "devops"
  vpc_security_group_ids = [aws_security_group.example.id ] 

  tags = {
    Name = "tf-example"
  }
}