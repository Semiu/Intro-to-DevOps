variable "instance_type" {
  type = string
}

variable "aws_region" {
  type = map(any)
}

variable "document_s3" {
  type = string
}