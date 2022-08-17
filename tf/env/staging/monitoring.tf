module "staging-monitoring" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/monitoring?ref=tf-module-monitoring-14"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  cluster_name = local.staging_cluster_name
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}
