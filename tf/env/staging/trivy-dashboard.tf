resource "google_monitoring_dashboard" "incoming-traffic" {
  dashboard_json = file("./trivy-dashboard-json.json")
  project        = "wikibase-cloud"

  timeouts {}
}
