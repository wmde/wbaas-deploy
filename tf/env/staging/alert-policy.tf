# https://www.percona.com/blog/2014/10/08/mysql-replication-got-fatal-error-1236-causes-and-cures/
#resource "google_logging_metric" "secondary-mariadb-server_errno-1236" {
#  name   = "secondary-sql-errno-1236-error-count"
#  filter = "resource.labels.cluster_name=\"wbaas-2\" AND resource.labels.pod_name=\"sql-mariadb-secondary-0\" AND textPayload:\"server_errno=1236\""
#  metric_descriptor {
#    metric_kind = "DELTA"
#    value_type  = "INT64"
#  }
#}
// condition_threshold {
//   filter          = "metric.name=\"secondary-sql-errno-1236-error-count\""
//   duration        = "60s"
//   comparison      = "COMPARISON_GT"
//   aggregations {
//     alignment_period     = "60s"
//     per_series_aligner   = "ALIGN_SUM"
//     cross_series_reducer = "REDUCE_SUM"
//   }

//   trigger {
//     count   = 1
//   }
// }

resource "google_monitoring_alert_policy" "alert_policy_replica_failure" {
  display_name = "SQL replica error 1236 alert policy"
  combiner     = "OR"
  conditions {
    display_name = "SQL replica errorno 1236"

    condition_matched_log {
      filter = "resource.labels.cluster_name=\"wbaas-2\" AND resource.labels.pod_name=\"sql-mariadb-secondary-0\" AND textPayload:\"server_errno=1236\""
    }
  }

  notification_channels = [ google_monitoring_notification_channel.basic ]

  alert_strategy {
    notification_rate_limit {
      period = "1h"
    }
  }
}

resource "google_monitoring_notification_channel" "basic" {
  display_name = "Test Notification Channel"
  type         = "email"
  labels = {
    email_address = "tobias.andersson@wikimedia.de"
  }
}