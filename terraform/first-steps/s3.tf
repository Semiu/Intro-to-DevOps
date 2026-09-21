module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "sem-tf" # state-store - to be used for the remote state store and manually created through console.
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "ObjectWriter"

  versioning = {
    enabled = true
  }
}