variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "monitoring_email_group_name" {
  type        = string
  description = "Name of the monitoring resource that will receive alerts"
}

variable "elasticsearch_metrics" {
  type        = set(string)
  description = "Metrics to look for in the json payload"
  default = [
    "heap.percent",
    "ram.percent",
    "disk.used_percent",
    "load_1m"
  ]
}

variable "platform_summary_metrics" {
  type        = set(string)
  description = "Metrics to look for in the json payload"
  default = [
    "total",
    "deleted",
    "empty",
    "total_non_deleted_users",
    "total_non_deleted_active_users",
    "total_non_deleted_pages",
    "total_non_deleted_edits",
    "total_items_count",
    "total_properties_count",
    "edited_last_90_days",
    "not_edited_last_90_days",
    "wikis_created_PT24H",
    "wikis_created_P30D",
    "users_created_PT24H",
    "users_created_P30D",
  ]
}

variable "environment" {
  type        = string
  description = "Human friendly name of the target environment. Example: production"
}
