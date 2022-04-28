terraform {
  required_version = "1.1.9"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.11.0"
    }
    scaleway = {
      source = "scaleway/scaleway"
      version = "2.2.1-rc.3"
    }
  }
}

provider "scaleway" {
  profile = "vinyl-catalog"
  zone   = "fr-par-1"
  region = "fr-par"
}

provider "aws" {
  profile = "vinyl-catalog"
  region = "eu-central-1"
}

module "aws_resources" {
  source = "./aws"
}

module "scaleway_resources" {
  source = "./scaleway"
}