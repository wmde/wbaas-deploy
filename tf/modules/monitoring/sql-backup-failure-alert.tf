## success logs
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
      duration = "88200s"
      trigger {
        count = 1
      }
    }
  }
}

## disk usage logs
resource "google_logging_metric" "sql_logical_backup_disk_usage" {
  name        = "${var.cluster_name}-sql-logic-backup-disk-usage"
  description = "A log based metric for monitoring sql logical backups disk usage."
  filter          = <<-EOT
        resource.type="k8s_container"
        resource.labels.cluster_name="${var.cluster_name}"
        resource.labels.pod_name:"sql-logic-backup"
        jsonPayload.wbaas_backup_scratch_disk_log="v1"
    EOT

  value_extractor = "REGEXP_EXTRACT(jsonPayload.diskUsage, \"(\\\\d+)\")" 

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "DISTRIBUTION"
  }

  bucket_options {
    exponential_buckets {
      growth_factor      = 2
      num_finite_buckets = 64
      scale              = 0.01
    }
  }
}

locals {
  sql_backup_disk_critical_usage_threshold = 0.80 # 80%, alert triggers if metric is above this value
}

resource "google_monitoring_alert_policy" "alert_policy_sql_logical_backup_high_disk_usage" {
  display_name = "(${var.cluster_name}): High disk usage for SQL logical backup"
  combiner     = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
  documentation {
    content = "Alert fires when the scratch disk used for the SQL backups runs on a high disk space usage (Above 80%)."
  }

  conditions {
    display_name = "(${var.cluster_name}): High disk usage for SQL logical backup"
    condition_threshold {
      filter   = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.sql_logical_backup_disk_usage.name}\" AND resource.type=\"k8s_container\""
      duration = "88200s"
      comparison = "COMPARISON_GT"
      threshold_value = local.sql_backup_disk_critical_usage_threshold

      aggregations {
        alignment_period     = "120s"
        per_series_aligner   = "ALIGN_PERCENTILE_50"
        cross_series_reducer = "REDUCE_NONE"
      }

      trigger {
        count = 1
      }
    }
  }
}
