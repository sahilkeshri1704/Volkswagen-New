resource "google_container_cluster" "gke" {
  name     = var.cluster_name
  location = var.region
  network  = var.network
  subnetwork = var.subnetwork

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes = true
  }

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "nodes" {
  name       = "default-pool"
  cluster    = google_container_cluster.gke.name
  location   = var.region
  node_count = 2

  node_config {
    machine_type = "e2-medium"
  }
}