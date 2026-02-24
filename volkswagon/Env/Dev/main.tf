# Attach service project to Shared VPC
resource "google_compute_shared_vpc_service_project" "service_project" {
  host_project    = var.host_project_id
  service_project = var.project_id
}

# Enable required APIs
resource "google_project_service" "required" {
  for_each = toset([
    "container.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com"
  ])
  service = each.key
}

# Private GKE Cluster
resource "google_container_cluster" "gke" {
  name     = "dev-gke"
  location = var.region
  network  = "projects/${var.host_project_id}/global/networks/${var.network_name}"
  subnetwork = "projects/${var.host_project_id}/regions/${var.region}/subnetworks/${var.subnet_name}"

  remove_default_node_pool = true
  initial_node_count       = 1

  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = true
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  ip_allocation_policy {}

  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }
}

resource "google_container_node_pool" "nodes" {
  name     = "primary-pool"
  cluster  = google_container_cluster.gke.name
  location = var.region
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    oauth_scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

# Cloud Armor
resource "google_compute_security_policy" "armor" {
  name = "dev-armor"

  rule {
    action   = "deny(403)"
    priority = 1000
    match {
      expr {
        expression = "evaluatePreconfiguredWaf('xss-v33-stable')"
      }
    }
  }

  rule {
    action   = "allow"
    priority = 2147483647
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
  }
}

# Monitoring Alert
resource "google_monitoring_alert_policy" "cpu_alert" {
  display_name = "High CPU"

  combiner = "OR"

  conditions {
    display_name = "CPU > 80%"
    condition_threshold {
      filter          = "metric.type=\"kubernetes.io/container/cpu/utilization\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.8
    }
  }
}