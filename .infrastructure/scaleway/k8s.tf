resource "scaleway_k8s_cluster" "main-cluster" {
  name    = "${var.project_name}-cluster"
  version = "1.23.4"
  cni     = "cilium"
  tags = [var.tag_environment]
}

resource "scaleway_k8s_pool" "main-pool" {
  # Link this pool to the cluster
  cluster_id = scaleway_k8s_cluster.main-cluster.id
  name       = "${var.project_name}-pool"
  # Define the node type we are going to be running
  node_type  = "DEV1-M"
  # The amount of nodes to run
  size       = 1
  autohealing = true
  autoscaling = false
  wait_for_pool_ready = true
  tags = [var.tag_environment]
}

resource "scaleway_registry_namespace" "main-image-registry" {
  name        = "${var.project_name}-registry"
  description = "Vinyl Catalog Container registry"
  ## This is a registry that is not publicly accessible
  ## Only with a token/authentication you'll be able to pull/push images
  is_public   = false
}