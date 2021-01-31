/* terraform {
  required_version = "~> 0.12.5"

  backend "s3" {
    hostname = "you s3 bucket name with your tfstate file"
    key = "terraform.tfstate"
    region = "us-east-1"

    workspaces{
        name = "default"
    }
  }
} */

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
