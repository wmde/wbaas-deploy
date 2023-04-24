module "metric-alarms" {
  source                      = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/metric-alarms?ref=tf-module-metric-alarms-1"
  cluster_name                = "wbaas-2"
  environment                 = "staging"
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}
