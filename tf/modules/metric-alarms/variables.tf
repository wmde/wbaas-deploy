variable "cluster_name" {
  type        = string
  description = "The name of the target GKE cluster. Example: wbaas-3"
}

variable "monitoring_email_group_name" {
  type        = string
  description = "Name of the monitoring resource that will receive alerts"
}

variable "environment" {
  type        = string
  description = "Human friendly name of the target environment. Example: production"
}

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
      condition_absent        = "120s"
    },
  }
}
