# see customReadinessProbe on the sql values.yaml
resource "google_logging_metric" "mariadb-replica-readiness-probe-failure" {
  name        = "mariadb-replica-readiness-probe-failure"
  description = "A log based metric for failures of the replica readiness probe lagging behind the primary"

  # Filter for the secondary pod and look for readiness probe failures
  filter = "resource.labels.cluster_name=\"${var.cluster_name}\" AND resource.labels.pod_name:\"sql-mariadb-secondary-\" AND resource.type=\"k8s_pod\" AND severity=WARNING AND jsonPayload.message:\"Readiness probe failed:\""

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_replica_readiniess_failure" {
  display_name = "(${var.cluster_name}): SQL replica readiness probe failure"
  combiner     = "OR"
  notification_channels = [
    google_monitoring_notification_channel.monitoring_email_group.name
  ]
  documentation {
    content = "Alert triggers when the replica state is lagging behind the master state by more than 60 seconds.\n For what are possible causes of a replication lag see [here](https://blogs.oracle.com/mysql/post/what-causes-replication-lag) "
  }
  conditions {
    display_name = "(${var.cluster_name}): SQL replica readiness probe failure"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.mariadb-replica-readiness-probe-failure.name}\" AND resource.type=\"k8s_pod\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "120s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
      trigger {
        count = 1
      }
    }
  }
}
