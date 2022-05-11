output "scaleway_cluster_id_output" {
  value = module.scaleway_resources.main-cluster-id
}

output "scaleway_lb_ip" {
  value = module.scaleway_resources.nginx-ip
}

output "scaleway_lb_ip_zone" {
  value = module.scaleway_resources.nginx-ip-zone
}