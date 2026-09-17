provider "random" {}

resource "random_pet" "name" {
  length = 3
}

output "random_pet_name" {
  value = random_pet.name.id
}