# credentials locally stored
provider "aws" {
  region = var.aws_region["east"] # from a map type. Can also do var.aws_region.east
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id       # "ami-0d729a60" is a type of instance that can be passed from another resource especially data source
  instance_type = var.instance_type            # Passed from the variable block
  subnet_id     = module.vpc.public_subnets[0] # Passed from the output file - a list of three subnests shows in the output. Just indexing one
  tags = {
    Name = "example"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH entry"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

  tags = {
    Name = "allow_ssh"
  }
}