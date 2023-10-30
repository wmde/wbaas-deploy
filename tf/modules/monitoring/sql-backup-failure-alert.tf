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
    "${var.monitoring_email_group_name}"
  ]
  documentation {
    content = "Alert fires when no SQL logical backup was created in the last 24.5 hours see [here](https://github.com/wmde/wbaas-deploy/blob/main/doc/backups/SQL/logical-sql-manually-taking-a-backup.md) for how to run backups manually."
  }

  conditions {
    display_name = "(${var.cluster_name}): SQL logical backup failure"
    condition_absent {
      filter   = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.sql_logical_backup_success.name}\" AND resource.type=\"k8s_container\""
      duration = "86400s"

      aggregations {
        cross_series_reducer = "REDUCE_COUNT"
        per_series_aligner = "ALIGN_COUNT"
        group_by_fields = "container_name"
      }
      trigger {
        count = 1
      }
    }
  }
}

locals {
  sql_backup_disk_critical_usage_threshold = 0.8 # 80%, alert triggers if metric is above this value
}

resource "google_monitoring_alert_policy" "alert_policy_sql_logical_backup_pv_critical_utilization" {
  display_name = "(${var.cluster_name}): critical SQL logical backup PV utilization"
  combiner     = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]

  documentation {
    content = "Alert fires when the PV used for the SQL backups is reaching a critical level (above ${local.sql_backup_disk_critical_usage_threshold * 100}%)."
  }

  conditions {
    display_name = "(${var.cluster_name}): critical SQL logical backup PV utilization"
    condition_threshold {
      filter = <<-EOT
                metric.type="kubernetes.io/pod/volume/utilization"
                resource.type="k8s_pod"
                resource.label.cluster_name="${var.cluster_name}"
                resource.label.pod_name=starts_with("sql-logic-backup-")
            EOT

      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = local.sql_backup_disk_critical_usage_threshold

      aggregations {
        alignment_period     = "120s"
        per_series_aligner   = "ALIGN_MAX"
        cross_series_reducer = "REDUCE_MAX"
      }

      trigger {
        count = 1
      }
    }
  }
}