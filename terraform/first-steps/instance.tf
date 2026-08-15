# credentials locally stored
provider "aws" {
  region = var.aws_region["east"] # from a map type. Can also do var.aws_region.east
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id # "ami-0d729a60" is a type of instance that can be passed from another resource especially data source
  instance_type = var.instance_type # Passed from the variable block
  tags = {
    Name = "example"
  }
}