locals {
  elasticsearch_pv_critical_utilization_threshold = 0.85 # 85%, alert triggers if metric is above this value
}

resource "google_monitoring_alert_policy" "alert_policy_elasticsearch_pv_critical_utilization" {
  display_name = "(${var.cluster_name}): critical Elastic Search PV utilization"
  combiner     = "OR"
  notification_channels = [
    google_monitoring_notification_channel.monitoring_email_group.name
  ]

  documentation {
    content = "Alert triggers when the disk space utilization of the Elastic Search data PV is reaching a critical level (over ${local.elasticsearch_pv_critical_utilization_threshold * 100}%)"
  }

  conditions {
    display_name = "(${var.cluster_name}): critical Elastic Search PV utilization"
    condition_threshold {
      filter = <<-EOT
                metric.type="kubernetes.io/pod/volume/utilization"
                resource.label."cluster_name"=${var.cluster_name}
                resource.label."service_name"="elasticsearch-master"
                resource.type="k8s_pod"
                metric.label."volume_name"="elasticsearch-master"
            EOT

      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = local.elasticsearch_pv_critical_utilization_threshold

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
