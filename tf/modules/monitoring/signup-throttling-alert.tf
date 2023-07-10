resource "google_logging_metric" "api_signup_throttling_applied" {
  name        = "${var.cluster_name}-api_signup_throttling_applied"
  description = "A log based metric that detects when api was throttling sign up attempts"

  # Filter for the secondary pod and look for readiness probe failures
  filter = "resource.labels.cluster_name=\"${var.cluster_name}\" AND resource.labels.pod_name:\"api-app-\" AND resource.type=\"k8s_pod\" AND severity=WARNING AND jsonPayload.message:\"WARN_SIGNUP_THROTTLED\""

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_alert_policy" "alert_api_signup_throttling_applied" {
  display_name = "(${var.cluster_name}): Signup was throttled"
  combiner     = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
  documentation {
    content = "Alert triggers when a user tried to create a wikibase.cloud account, but the configured limits were already exceeded."
  }
  conditions {
    display_name = "(${var.cluster_name}): Signup was throttled"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.api_signup_throttling_applied}\" AND resource.type=\"k8s_pod\""
      duration   = "0s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "300s"
        per_series_aligner   = "ALIGN_SUM"
        cross_series_reducer = "REDUCE_SUM"
      }
      trigger {
        count = 1
      }
    }
  }
}
