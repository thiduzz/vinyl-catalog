output "main-cluster-id" {
  value = scaleway_k8s_cluster.main-cluster.id
  description = "The ID of our main cluster."
}

output "nginx-ip" {
  value = scaleway_lb_ip.nginx_ip.ip_address
  description = "The IP of our main cluster."
}

output "nginx-ip-zone" {
  value = scaleway_lb_ip.nginx_ip.zone
  description = "The zone of the IP of our main cluster."
}

#output "vpc-public-ip" {
#  value = scaleway_vpc_public_gateway_ip.main-public-gateway-ip.address
#  description = "The IP of our VPC Internet Gateway"
#}
