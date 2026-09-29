provider "aws" {

  region = var.aws_region["east"]
}

provider "aws" {
  alias  = "west"
  region = var.aws_region["west"]
}