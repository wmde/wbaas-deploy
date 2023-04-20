module "metric-alarms" {
  source                      = "./../../modules/metric-alarms"
  cluster_name                = "wbaas-2"
  environment                 = "staging"
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}
