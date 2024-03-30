data "aws_ami" "al_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami*"]
  }
}

resource "aws_instance" "myec2" {
  count         = 2
  ami           = data.aws_ami.al_ami.id
  instance_type = var.instance_type
  key_name      = "terraform_ec2_key"
  subnet_id     = data.terraform_remote_state.vpc.outputs.subnet_id
}

resource "aws_iam_user" "user-count" {
  count = var.environment == "production" ? 1 : 0
  name  = var.names[count.index]
}

#Convertimos la lista en un set porque sino no funciona el foreach.
resource "aws_iam_user" "user-foreach" {
  for_each = toset(var.names)
  name     = each.key
}

data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../laboratorio/terraform.tfstate"
  }
}


