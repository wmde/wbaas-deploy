resource "google_monitoring_dashboard" "platform-summary" {
  dashboard_json = file("./platform-summary-dashboard-json.json")
  project = "wikibase-cloud"

  timeouts {}
}
