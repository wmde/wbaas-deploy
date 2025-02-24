resource "google_monitoring_dashboard" "incoming-traffic" {
  dashboard_json = file("./incoming-traffic-dashboard-json.json")
  project        = "wikibase-cloud"

  timeouts {}
}
