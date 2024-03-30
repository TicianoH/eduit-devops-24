output "my_instance_pubIP" {
  value = aws_instance.myec2.public_ip
}

output "myinstance_todo" {
  value = aws_instance.myec2
}