resource "google_monitoring_alert_policy" "alert_policy_prometheus_metric" {
  for_each = local.alarms

  display_name = "Metric check failed (${var.environment}): ${each.value.display_name}"

  documentation {
    content = "This alert fires if the metric ${each.value.display_name} does not meet its expected status."
  }

  conditions {
    display_name = each.value.display_name
    condition_threshold {
      filter                  = "resource.type = \"prometheus_target\" AND resource.labels.cluster = \"${var.cluster_name}\" AND ${each.value.filter}"
      evaluation_missing_data = each.value.evaluation_missing_data
      aggregations {
        alignment_period     = each.value.alignment_period
        cross_series_reducer = each.value.cross_series_reducer
        per_series_aligner   = each.value.per_series_aligner
      }
      comparison = each.value.comparison
      duration   = each.value.duration
      trigger {
        count = each.value.trigger_count
      }
      threshold_value = each.value.threshold_value
    }
  }
  combiner = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
}
