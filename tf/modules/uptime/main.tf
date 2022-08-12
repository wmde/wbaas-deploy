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

resource "google_monitoring_alert_policy" "alert_policy_https-content-uptime-check"{
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
           alignment_period = "120s"
          cross_series_reducer = "REDUCE_COUNT_FALSE"
          group_by_fields = [
            "resource.label.project_id",
            "resource.label.host"
          ]
          per_series_aligner = "ALIGN_NEXT_OLDER"
      }
        comparison = "COMPARISON_GT"
        duration = "60s"
        trigger {
          count = 1
        }
        threshold_value = 1
    }
  }
  combiner = "OR"
  notification_channels = [
    google_monitoring_notification_channel.uptime_monitoring_email_group.name
  ]
}

resource "google_monitoring_notification_channel" "uptime_monitoring_email_group" {
  display_name = "Wikibase cloud Email-Notification Channel"
  type         = "email"
  labels = {
    email_address = "wb-cloud-monitoring@wikimedia.de"
  }
}