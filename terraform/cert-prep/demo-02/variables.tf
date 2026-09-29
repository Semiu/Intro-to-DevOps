variable "aws_region" {
  type = map(any)
  default = {
    "east" = "us-east-1"
    "west" = "us-west-1"
  }
}

variable "buckets_east" {
  type = map(string)
  default = {
    "terraform-bucket" = "demo-2-terraform-bucket-east"
    "backup-bucket"    = "demo-2-backup-bucket-east"
  }
}

variable "buckets_west" {
  type = map(string)
  default = {
    "terraform-bucket" = "demo-2-terraform-bucket-west"
    "backup-bucket"    = "demo-2-backup-bucket-west"
  }
}