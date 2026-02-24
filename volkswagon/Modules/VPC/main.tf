resource "google_compute_network" "vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

output "network_id" {
  value = google_compute_network.vpc.id
}