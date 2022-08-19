module "uptime-checks" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/uptime?ref=tf-module-uptime-3"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  target_wiki = "coffeebase.wikibase.dev"
  target_wbaas_hostname = "wikibase.dev"

  wikibase_itempage_item = "Q1"
  wikibase_itempage_content = "Arabica"

  project_id = local.project_id
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}