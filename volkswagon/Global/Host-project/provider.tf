provider "google" {
  project = var.service_project_id
  region  = var.region
}

provider "google" {
  alias   = "host"
  project = var.host_project_id
  region  = var.region
}