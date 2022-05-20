terraform {
  required_version = "1.1.9"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.14.0"
    }

    scaleway = {
      source  = "scaleway/scaleway"
      version = "2.2.1-rc.3"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.5.1"
    }
  }
}

provider "scaleway" {
  profile = "vinyl-catalog"
  zone    = "fr-par-1"
  region  = "fr-par"
}

provider "aws" {
  region  = "eu-central-1"
}

provider "helm" {
  kubernetes {
    config_context = "admin@vinyl-catalog-cluster-78e28698-4011-496a-b63f-004652541296"
    config_path = "~/.kube/config"
  }
}

module "aws_resources" {
  source = "./aws"
  project_name = var.project_name
  tag_environment = var.tag_environment
  vpc_cidr = var.vpc_cidr
  public_subnet_range = var.public_subnet_range
  public_subnet_range_2 = var.public_subnet_range_2
  public_subnet_range_3 = var.public_subnet_range_3
  scaleway_ips = var.scaleway_ips
  #  private_subnet_range = var.private_subnet_range
}

module "scaleway_resources" {
  source = "./scaleway"
  project_name = var.project_name
  tag_environment = var.tag_environment
}

module "k8s_resources" {
  source = "./k8s"
  project_name = var.project_name
  tag_environment = var.tag_environment
  nginx_ip = module.scaleway_resources.nginx-ip
  nginx_zone = module.scaleway_resources.nginx-ip-zone
}