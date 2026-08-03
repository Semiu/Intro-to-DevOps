// credentials locally stored
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "example" {
  ami           = "ami-0d729a60" // a type of instance that is
  instance_type = "t2.micro"
}