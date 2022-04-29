output "main-cluster-id" {
  value = scaleway_k8s_cluster.main-cluster.id
  description = "The ID of our main cluster."
}