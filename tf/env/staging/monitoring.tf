module "staging-monitoring" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/monitoring?ref=tf-module-monitoring-17"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  cluster_name                = local.staging_cluster_name
  environment                 = "staging"
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}
