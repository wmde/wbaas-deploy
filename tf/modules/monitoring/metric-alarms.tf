locals {
  alarms = {
    "es-cluster-health-${var.environment}" = {
      display_name            = "Elasticsearch Cluster Health Status"
      filter                  = "metric.type = \"prometheus.googleapis.com/elasticsearch_cluster_health_status/gauge\" AND metric.labels.color = \"green\""
      comparison              = "COMPARISON_LT"
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      trigger_count           = 1
      threshold_value         = 1
      duration                = "60s"
      condition_absent        = "300s"
      min_group_by            = "metric.label.es_cluster"
    },
    "es-cluster-available-shards-${var.environment}" = {
      display_name            = "Elasticsearch Cluster available shards"
      filter                  = "metric.type = \"prometheus.googleapis.com/elasticsearch_node_shards_total/gauge\""
      comparison              = "COMPARISON_GT"
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      trigger_count           = 1
      # Currently there is a hard limit of 800 shards per node set via REST API.
      # The alarm is expected to trigger on 90% usage
      threshold_value  = 720
      duration         = "60s"
      condition_absent = "300s"
      min_group_by     = "metric.label.es_cluster"
    },
    "api-qs-batches-backpressure-${var.environment}" = {
      display_name            = "Platform API Queryservice Batches Backpressure"
      filter                  = "metric.type = \"prometheus.googleapis.com/platform_api_qs_batches_pending/gauge\""
      comparison              = "COMPARISON_GT"
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      trigger_count           = 1
      threshold_value         = 100
      duration                = "60s"
      condition_absent        = "300s"
      min_group_by            = "metric.label.cluster"
    },
  }
}

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
      comparison              = each.value.comparison
      duration                = each.value.duration
      trigger {
        count = each.value.trigger_count
      }
      threshold_value = each.value.threshold_value
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MIN"
        group_by_fields = [
          each.value.min_group_by,
        ]
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  conditions {
    display_name = "${each.value.display_name} absent"
    condition_absent {
      duration = each.value.condition_absent
      filter   = "resource.type = \"prometheus_target\" AND resource.labels.cluster = \"${var.cluster_name}\" AND ${each.value.filter}"
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MIN"
        group_by_fields = [
          each.value.min_group_by,
        ]
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }
  combiner = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
}
