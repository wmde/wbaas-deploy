resource "google_monitoring_uptime_check_config" "https-content-uptime-check" {
  for_each = local.checks

  display_name = each.value.name
  timeout = "60s"
  selected_regions = []

  http_check {
    path = each.value.path
    port = "443"
    use_ssl = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = each.value.host
      project_id = var.project_id
    }
  }

  content_matchers {
    content = each.value.content
  }
}