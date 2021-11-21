terraform {
  required_version = ">= 1.0.0"

  backend "s3" {
    bucket = "star-app-bucket"
    key    = "terraform.tfstate"
    region = "eu-west-3"
  }
}