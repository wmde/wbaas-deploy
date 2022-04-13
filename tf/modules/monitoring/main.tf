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
  display_name = "SQL replica error 1236 alert policy"
  combiner     = "OR"
  notification_channels = [ 
    google_monitoring_notification_channel.monitoring_email_group.name
  ]
  conditions {
    display_name = "(${var.cluster_name}): SQL replica errorno 1236"
    condition_absent {
    # resource.type needed because of https://github.com/hashicorp/terraform-provider-google/issues/4165
    filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.mariadb-server_errno-1236.name}\" AND resource.type=\"k8s_container\""
    duration        = "60s"

    aggregations {
      alignment_period     = "60s"
      per_series_aligner   = "ALIGN_RATE"
      cross_series_reducer = "REDUCE_SUM"
    }
    trigger {
      count   = 1
    }
  }
 }
}

resource "google_monitoring_notification_channel" "monitoring_email_group" {
  display_name = "Wikibase cloud (${var.cluster_name}) Email-Notification Channel"
  type         = "email"
  labels = {
    email_address = "${var.email_group}"
  }
}
