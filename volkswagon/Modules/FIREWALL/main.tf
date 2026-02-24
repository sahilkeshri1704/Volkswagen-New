resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = var.network

  allow {
    protocol = "tcp"
  }

  source_ranges = ["10.0.0.0/8"]
}