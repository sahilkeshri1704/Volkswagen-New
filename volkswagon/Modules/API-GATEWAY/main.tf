resource "google_api_gateway_api" "api" {
  api_id = "sample-api"
}

resource "google_api_gateway_gateway" "gateway" {
  gateway_id = "sample-gateway"
  api        = google_api_gateway_api.api.name
  region     = var.region
}

##