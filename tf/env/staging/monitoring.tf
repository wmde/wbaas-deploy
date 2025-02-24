module "staging-monitoring" {
  source = "../../modules/monitoring"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  cluster_name                = local.staging_cluster_name
  environment                 = "staging"
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}
