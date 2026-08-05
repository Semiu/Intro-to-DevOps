// credentials locally stored
provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["ubuntu-minimal/images/hvm-ssd/ubuntu-focal-20.04-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id //"ami-0d729a60" is a type of instance that. Can be passed from another resource especially data source
  instance_type = "t2.micro"
  tags = {
    Name = "example"
  }
}