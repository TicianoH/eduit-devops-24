provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "prueba" {
  vpc_id = ""
  ami           = "ami-0c101f26f147fa7fd"
  instance_type = "t2.micro"
  #aws_security_group_ids = [data.terraform_remote_state.carpeta1.my_instance_pubIP]
  tags = {
  Name          = "ec2-test"
  }
}

data "terraform_remote_state" "carpeta1" {
  backend = "remote"

#  s3 {
#
#  }
}