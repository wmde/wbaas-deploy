locals {
  sql_pv_critical_utilization_threshold = 0.7 # 70%, alert triggers if metric is above this value
}

resource "google_monitoring_alert_policy" "alert_policy_sql_primary_pv_critical_utilization" {
  display_name = "(${var.cluster_name}): critical SQL primary PV utilization"
  combiner     = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]

  documentation {
    content = "Alert triggers when the disk space utilization of the SQL primary data PV is reaching a critical level (over ${local.sql_pv_critical_utilization_threshold * 100}%)"
  }

  conditions {
    display_name = "(${var.cluster_name}): critical SQL primary PV utilization"
    condition_threshold {
      filter = <<-EOT
                metric.type="kubernetes.io/pod/volume/utilization"
                resource.label."cluster_name"=${var.cluster_name}
                resource.label."pod_name"="sql-mariadb-primary-0"
                resource.type="k8s_pod"
                metric.label."volume_name"="data"
            EOT

      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = local.sql_pv_critical_utilization_threshold

      aggregations {
        alignment_period     = "120s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }
}

resource "google_monitoring_alert_policy" "alert_policy_sql_secondary_pv_critical_utilization" {
  display_name = "(${var.cluster_name}): critical SQL secondary PV utilization"
  combiner     = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]

  documentation {
    content = "Alert triggers when the disk space utilization of the SQL secondary data PV is reaching a critical level (over ${local.sql_pv_critical_utilization_threshold * 100}%)"
  }

  conditions {
    display_name = "(${var.cluster_name}): critical SQL secondary PV utilization"
    condition_threshold {
      filter = <<-EOT
                metric.type="kubernetes.io/pod/volume/utilization"
                resource.label."cluster_name"=${var.cluster_name}
                resource.label."pod_name"="sql-mariadb-secondary-0"
                resource.type="k8s_pod"
                metric.label."volume_name"="data"
            EOT

      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = local.sql_pv_critical_utilization_threshold

      aggregations {
        alignment_period     = "120s"
        per_series_aligner   = "ALIGN_MEAN"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }
}
