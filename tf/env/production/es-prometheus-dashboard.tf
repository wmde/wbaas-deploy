# google_monitoring_dashboard.elasticsearch-prometheus:
resource "google_monitoring_dashboard" "elasticsearch-prometheus" {
  dashboard_json = file("./es-prometheus-dashboard-json.json")
  project        = "658442145969"

  timeouts {}
}
