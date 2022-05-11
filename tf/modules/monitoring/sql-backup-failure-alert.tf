resource "google_logging_metric" "sql_logical_backup_success" {
  name        = "${var.cluster_name}-sql-logic-backup"
  description = "A log based metric for monitoring sql logical backups."
  filter      = "resource.labels.cluster_name=\"${var.cluster_name}\" AND resource.labels.pod_name:\"sql-logic-backup\" AND resource.type=\"k8s_container\" AND severity=INFO AND textPayload:\"Finished dump at:\""

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_sql_logical_backup_failure" {
  display_name = "(${var.cluster_name}): SQL logical backup failure"
  combiner     = "OR"
  notification_channels = [
    google_monitoring_notification_channel.monitoring_email_group.name
  ]
  documentation {
    content = "Alert fires when no SQL logical backup was created in the last 24 hours see [here](https://github.com/wmde/wbaas-deploy/blob/main/doc/backups/SQL/logical-sql-manually-taking-a-backup.md) for how to run backups manually."
  }

  conditions {
    display_name = "(${var.cluster_name}): SQL logical backup failure"
    condition_absent {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.sql_logical_backup_success.name}\" AND resource.type=\"k8s_container\""
      duration   = "86400s"
      trigger {
        count = 1
      }
    }
  }
}