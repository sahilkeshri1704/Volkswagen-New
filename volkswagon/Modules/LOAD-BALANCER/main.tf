resource "google_compute_backend_service" "backend" {
  name        = "backend-service"
  protocol    = "HTTP"
  port_name   = "http"
  timeout_sec = 30
}