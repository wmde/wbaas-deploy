#https://www.percona.com/blog/2014/10/08/mysql-replication-got-fatal-error-1236-causes-and-cures/
resource "google_logging_metric" "mariadb-server_errno-1236" {
  name   = "${var.cluster_name}-mariadb-sql-errno-1236-error-count"
  filter = "resource.labels.cluster_name=\"${var.cluster_name}\" AND resource.labels.container_name=\"mariadb\" AND textPayload:\"server_errno=1236\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_monitoring_alert_policy" "alert_policy_replica_failure" {
  display_name = "(${var.cluster_name}): SQL replica error 1236 alert policy"
  combiner     = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
  documentation {
    content = "**Alert trigger when SQL replication fails on the MariaDB replica database with error code 1236.**\nThis error occurs when the slave server required binary log for replication no longer exists on the master database server. In one of the scenarios for this, the slave server is stopped for some reason for a few hours/days and when you resume replication on the slave it fails with the above error. see [here](https://www.percona.com/blog/2014/10/08/mysql-replication-got-fatal-error-1236-causes-and-cures/)"
  }
  conditions {
    display_name = "(${var.cluster_name}): SQL replica errorno 1236"
    condition_threshold {
      # resource.type needed because of https://github.com/hashicorp/terraform-provider-google/issues/4165
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.mariadb-server_errno-1236.name}\" AND resource.type=\"k8s_container\""
      duration   = "60s"
      comparison = "COMPARISON_GT"
      aggregations {
        alignment_period     = "1200s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }
      trigger {
        count = 1
      }
    }
  }
}
