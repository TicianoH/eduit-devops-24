terraform {
  required_version = ">= 1.3.9"
  backend "s3" {
    bucket = "curso-devops-24-tjh"
    key    = "terraform"
    region = "us-east-1"
    dynamodb_table = "terraform"
  }
  
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.32"
    }
    github = {
      source = "integrations/github"
      version = "5.35.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}
