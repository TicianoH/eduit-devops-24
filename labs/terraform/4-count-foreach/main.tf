resource "aws_instance" "myec2" {
  count = 2
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name = "devops"
}

resource "aws_iam_user" "user-count" {
    count = 2
    name = var.names[count.index]
}

#Convertimos la lista en un set porque sino no funciona el foreach.
resource "aws_iam_user" "user-foreach" {
    for_each = toset(var.names)
    name = each.key
}



