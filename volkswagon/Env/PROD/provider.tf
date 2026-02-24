# In provider.tf or versions.tf
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # Specify a recommended version constraint
    }
  }
}

# In provider.tf
provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  # zone    = var.gcp_zone # Optional: for zonal resources
}