variable "project_name" {
  type        = string
  description = "The name of the project"
}

variable "tag_environment" {
  type        = string
  description = "The name of the environment"
}

variable "nginx_ip" {
  type        = string
  description = "LB IP used to communicate with the K8s cluster ingress"
}

variable "nginx_zone" {
  type        = string
  description = "Zone in which our LB is created"
}