resource "google_monitoring_uptime_check_config" "https-content-uptime-check" {
  for_each = local.checks

  display_name     = each.value.name
  timeout          = "60s"
  selected_regions = []

  http_check {
    path         = each.value.path
    port         = "443"
    use_ssl      = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host       = each.value.host
      project_id = var.project_id
    }
  }

  content_matchers {
    content = each.value.content
    matcher = each.value.matcher
    dynamic "json_path_matcher" {
      for_each = each.value.matcher == "NOT_MATCHES_JSON_PATH" ? toset([1]) : toset([])
      content {
        json_matcher = each.value.json_matcher
        json_path    = each.value.json_path
      }
    }
  }
}

resource "google_monitoring_alert_policy" "alert_policy_https-content-uptime-check" {
  for_each = google_monitoring_uptime_check_config.https-content-uptime-check

  display_name = "Uptime Health Check: ${each.value.display_name}"
  documentation {
    content = "This alert fires if the service ${each.value.display_name} is down. That is; the uptime-check metric check_passed is false."
  }
  conditions {
    display_name = "Uptime Health Check: ${each.value.display_name}"
    condition_threshold {
      filter = "resource.type = \"uptime_url\" AND metric.type = \"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.labels.check_id = ${each.value.uptime_check_id}"
      aggregations {
        alignment_period     = "18000s" # 5hours
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields = [
          "resource.label.project_id",
          "resource.label.host"
        ]
        per_series_aligner = "ALIGN_NEXT_OLDER"
      }
      comparison = "COMPARISON_GT"
      duration   = "300s"
      trigger {
        count = 1
      }
      threshold_value = 1
    }
  }
  combiner = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
}