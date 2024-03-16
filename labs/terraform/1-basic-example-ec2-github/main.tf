terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.16.1"
    }
    github = {
      source = "integrations/github"
      version = "5.35.0"
    }
  }
  
}

provider "aws" {

}

resource "aws_instance" "myec2" {
  ami           = "ami-08a52ddb321b32a8c"
  instance_type = "t2.micro"
  key_name      = "devops"

  tags = {
    Name = "tf-example"
  }
}

provider "github" {
 
}


resource "github_repository" "example" {
  name               = "my-repo-example"
  description        = "My awesome codebase"
  visibility         = "private"
  allow_merge_commit = true
  allow_rebase_merge = true
  allow_squash_merge = true
}
