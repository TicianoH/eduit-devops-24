#En esta sección del código, configuramos la región que utilizaremos en el proveedor. 
provider "aws" {
  region     = "us-east-1"
}

#En este recurso, crearemos una VPC, una sección privada de la nube donde crearemos nuestros recursos
resource "aws_vpc" "laboratorio" {
#  for_each = 
  cidr_block = "10.0.0.0/16"
}

#Dentro de la VPC, creamos una subnet, la cual es una sección de la VPC con una zona asignada para crear los recursos en dicha zona y en dicha red 
resource "aws_subnet" "subnet-1" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.laboratorio.id
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
}

#Para poder acceder desde internet a nuestra red privada, necesitamos un recurso de tipo Internet Gateway
resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.laboratorio.id
}

#Además, necesitamos crear una tabla de ruteo, donde configuramos la ruta para acceder a internet desde nuestra red privada 
resource "aws_route_table" "prod-public-crt" {
    vpc_id = aws_vpc.laboratorio.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.igw.id
    }
}

#Luego, asociamos la tabla de ruteo recién creada con la subnet donde crearemos nuestra máquina virtual 
resource "aws_route_table_association" "prod-crta-public-subnet-1"{
    subnet_id = aws_subnet.subnet-1.id
    route_table_id = aws_route_table.prod-public-crt.id
}

#Seguimos con los recursos de red/seguridad, donde en este caso asociamos un recurso de tipo security group a nuestra vpc el cual permite acceder al puerto 22 desde cualquier ip (0.0.0.0/0, en caso de querer hacer el acceso más restringido, pueden cambiarlo por la IP pública de su casa, tener en cuenta que esta IP es dinamica) 
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  vpc_id      = aws_vpc.laboratorio.id 

  ingress {
    description      = "ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

#En este caso para facilidad, le decimos a Terraform que luego de crear el código nos devuelva la IP pública de la instancia para poder conectarnos 
output "instance_ip" {
  description = "The public ip for ssh access"
  value       = aws_instance.instancia.public_ip
}

output "subnet_id" {
  value = aws_subnet.subnet-1.id
}

#Ya lista nuestra red, configuramos nuestra instancia 
resource "aws_instance" "instancia" {
  ami           = "ami-004dac467bb041dc7"
  instance_type = "t2.micro"
  key_name = aws_key_pair.terraform_ec2_key.key_name
  associate_public_ip_address = true
  subnet_id = aws_subnet.subnet-1.id
  security_groups = [aws_security_group.ssh.id]
}

#Y por último, le decimos a la instancia que agregue nuestra llave pública de ssh generada antes para poder conectarnos con la llave privada luego. 
resource "aws_key_pair" "terraform_ec2_key" {
	key_name = "terraform_ec2_key"
	public_key = "${file("ansible.key.pub")}"
}

