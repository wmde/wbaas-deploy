module "uptime-checks" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/uptime?ref=tf-module-uptime-4"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  target_wiki = "cloud-coffeebase.wikibase.cloud"
  target_wbaas_hostname = "wikibase.cloud"

  wikibase_itempage_item = "Q1"
  wikibase_itempage_content = "I like coffee"

  project_id = local.project_id
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}