module "staging-monitoring" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/monitoring?ref=tf-module-monitoring-23"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  cluster_name                = local.staging_cluster_name
  environment                 = "staging"
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
  platform_summary_metrics = toset([
    "active",
    "total",
    "deleted",
    "inactive",
    "empty",
    "total_non_deleted_users",
    "total_non_deleted_active_users",
    "total_non_deleted_pages",
    "total_non_deleted_edits",
    "wikis_created_PT24H",
    "wikis_created_P30D",
    "users_created_PT24H",
    "users_created_P30D",
  ])
}
