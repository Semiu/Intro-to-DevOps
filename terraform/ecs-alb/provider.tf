provider "aws" {
  region = var.aws_region["east"] # from a map type. Can also do var.aws_region.east
}