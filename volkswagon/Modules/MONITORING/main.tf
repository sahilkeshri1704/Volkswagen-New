resource "google_monitoring_alert_policy" "cpu_alert" {
  display_name = "High CPU Alert"
  combiner     = "OR"

  conditions {
    display_name = "CPU > 80%"
    condition_threshold {
      filter = "metric.type=\"kubernetes.io/container/cpu/utilization\""
      duration = "60s"
      comparison = "COMPARISON_GT"
      threshold_value = 0.8
    }
  }
}