variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "tag_environment" {
  type        = string
  description = "The name of the environment"
}

variable "vpc_cidr" {
  type        = string
  description = "The base CIDR for our VPC"
}

variable "public_subnet_range" {
  type        = string
  description = "A range of IPs contained in our VPC base CIDR"
}

variable "public_subnet_range_2" {
  type        = string
  description = "A range of IPs contained in our VPC base CIDR"
}

variable "public_subnet_range_3" {
  type        = string
  description = "A range of IPs contained in our VPC base CIDR"
}

variable "scaleway_ips" {
  type    = list(string)
  description = "A list of IPs we want AWS to whitelist"
}

#variable "private_subnet_range" {
#  type        = string
#  description = "The name of the environment"
#}