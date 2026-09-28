/**
provider "github" {
  token = var.github_token

}

resource "github_repository" "prod-repo" {
  name        = "prod-repo"
  description = "Production repo"
  visibility    = "private"

}

resource "github_repository" "test-repo" {
  name        = "test-repo"
  description = "Testing repo"
  visibility    = "private"

}
*/