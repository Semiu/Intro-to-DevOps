variable "aws_region" {
  type = map(any)
  default = {
    "west" = "us-west-2"
    "east" = "us-east-1"
  }
}