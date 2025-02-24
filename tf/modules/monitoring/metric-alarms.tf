locals {
  alarms = {
    "api-qs-batches-backpressure-${var.environment}" = {
      display_name            = "Platform API Queryservice Batches Backpressure"
      filter                  = "metric.type = \"prometheus.googleapis.com/platform_api_qs_batches_pending_batches/gauge\""
      comparison              = "COMPARISON_GT"
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      trigger_count           = 1
      threshold_value         = 100
      duration                = "60s"
      condition_absent        = "300s"
      min_group_by            = "metric.label.cluster"
    },
  }

  elasticsearch = {
    health = {
      "yellow-${var.environment}" = {
        display_name = "Elasticsearch Cluster Health Yellow"
        color        = "yellow"
        duration     = "900s"
      },
      "red-${var.environment}" = {
        display_name = "Elasticsearch Cluster Health Red"
        color        = "red"
        duration     = "60s"
      }
    }

    shards = {
      "shard-count-${var.environment}" = {
        display_name = "Elasticsearch Document Count"
        metric       = "elasticsearch_indices_shards_docs"
        # 75% of the 200M max documents per shard recommendation
        threshold = "150000000"
      },
      "shard-size-${var.environment}" = {
        display_name = "Elasticsearch Shard Size"
        metric       = "elasticsearch_indices_shards_store_size_in_bytes"
        # 75% of the 50GB max shard size recommendation
        threshold = "37500000000"
      }
    }
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

resource "google_monitoring_alert_policy" "alert_policy_prometheus_metric_elasticsearch_health" {
  for_each = local.elasticsearch.health

  display_name = "Metric check failed (${var.environment}): ${each.value.display_name}"

  documentation {
    content = "This alert fires if the metric ${each.value.display_name} does not meet its expected status."
  }

  conditions {
    display_name = each.value.display_name
    condition_threshold {
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      comparison              = "COMPARISON_GT"
      duration                = each.value.duration
      filter = join(" AND ", [
        "resource.type = \"prometheus_target\"",
        "resource.labels.cluster = \"${var.cluster_name}\"",
        "metric.type = \"prometheus.googleapis.com/elasticsearch_cluster_health_status/gauge\"",
        "metric.labels.color = \"${each.value.color}\""
      ])
      trigger {
        count = 1
      }
      threshold_value = 0
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields = [
          "metric.label.es_cluster",
        ]
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }
  conditions {
    display_name = "${each.value.display_name} absent"
    condition_absent {
      duration = "300s"
      filter = join(" AND ", [
        "resource.type = \"prometheus_target\"",
        "resource.labels.cluster = \"${var.cluster_name}\"",
        "metric.type = \"prometheus.googleapis.com/elasticsearch_cluster_health_status/gauge\"",
        "metric.labels.color = \"${each.value.color}\""
      ])
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields = [
          "metric.label.es_cluster",
        ]
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }
  combiner = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
}

resource "google_monitoring_alert_policy" "alert_policy_prometheus_metric_elasticsearch_shards" {
  for_each = local.elasticsearch.shards

  display_name = "Metric check failed (${var.environment}): ${each.value.display_name}"

  documentation {
    content = "This alert fires if the metric ${each.value.display_name} does not meet its expected status."
  }

  conditions {
    display_name = each.value.display_name
    condition_threshold {
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      comparison              = "COMPARISON_GT"
      duration                = "300s"
      filter = join(" AND ", [
        "resource.type = \"prometheus_target\"",
        "resource.labels.cluster = \"${var.cluster_name}\"",
        "metric.type = \"prometheus.googleapis.com/${each.value.metric}/gauge\""
      ])
      trigger {
        count = 1
      }
      threshold_value = each.value.threshold
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields = [
          "metric.label.es_cluster",
        ]
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }
  conditions {
    display_name = "${each.value.display_name} absent"
    condition_absent {
      duration = "300s"
      filter = join(" AND ", [
        "resource.type = \"prometheus_target\"",
        "resource.labels.cluster = \"${var.cluster_name}\"",
        "metric.type = \"prometheus.googleapis.com/${each.value.metric}/gauge\""
      ])
      aggregations {
        alignment_period     = "300s"
        cross_series_reducer = "REDUCE_MAX"
        group_by_fields = [
          "metric.label.es_cluster",
        ]
        per_series_aligner = "ALIGN_MAX"
      }
    }
  }
  combiner = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
}

resource "google_monitoring_alert_policy" "alert_policy_prometheus_metric_elasticsearch_breakers" {
  display_name = "Metric check failed (${var.environment}): Elasticsearch Breakers Tripped"

  documentation {
    content = "This alert fires if the metric Elasticsearch Breakers Tripped does not meet its expected status."
  }

  conditions {
    display_name = "Elasticsearch Breakers Tripped"
    condition_threshold {
      evaluation_missing_data = "EVALUATION_MISSING_DATA_ACTIVE"
      comparison              = "COMPARISON_GT"
      duration                = "3600s"
      filter = join(" AND ", [
        "resource.type = \"prometheus_target\"",
        "resource.labels.cluster = \"${var.cluster_name}\"",
        "metric.type = \"prometheus.googleapis.com/elasticsearch_breakers_tripped/counter\""
      ])
      trigger {
        count = 1
      }
      threshold_value = 10
      aggregations {
        alignment_period     = "3600s"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = [
          "metric.label.es_cluster",
        ]
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }
  conditions {
    display_name = "Elasticsearch Breakers Tripped absent"
    condition_absent {
      duration = "300s"
      filter = join(" AND ", [
        "resource.type = \"prometheus_target\"",
        "resource.labels.cluster = \"${var.cluster_name}\"",
        "metric.type = \"prometheus.googleapis.com/elasticsearch_breakers_tripped/counter\""
      ])
      aggregations {
        alignment_period     = "3600s"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields = [
          "metric.label.es_cluster",
        ]
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }
  combiner = "OR"
  notification_channels = [
    "${var.monitoring_email_group_name}"
  ]
}
