/***
terraform {
  backend "s3" {
    bucket = "sem-tf-state-store"
    key    = "backend/terraform.tfstate"
    region = "us-east-1"

    dynamodb_table = "terraform-locking" # Must have partition key of name LockID with type String

  }
}
*/