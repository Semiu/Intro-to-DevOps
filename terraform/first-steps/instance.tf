# credentials locally stored
provider "aws" {
  region = var.aws_region["east"] # from a map type. Can also do var.aws_region.east
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id       # "ami-0d729a60" is a type of instance that can be passed from another resource especially data source
  instance_type = var.instance_type            # Passed from the variable block
  subnet_id     = module.vpc.public_subnets[0] # Passed from the output file - a list of three subnests shows in the output. Just indexing one

  vpc_security_group_ids = [aws_security_group.allow_ssh.id] //something like sg-123456
  key_name               = aws_key_pair.webkey.key_name

  //start - `user_data`
  //user_data = templatefile("${path.module}/templates/web.tpl", {
  //"region" = var.aws_region["east"]
  //})
  //end- `user_data

  // for provisoner - when `user_data is not used
  user_data_replace_on_change = true

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("webkey") # Read the .gitignored file
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = ["sudo apt-get update", "sudo apt-get -y install nginx"]

  }
  // end - provisioner
  tags = {
    Name = "example"
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH entry"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
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

resource "aws_key_pair" "webkey" {
  key_name   = "web-ssh-key"
  public_key = file("webkey.pub") # Read the .gitignored file
}