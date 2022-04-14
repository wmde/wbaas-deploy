module "uptime-checks" {
  source = "./../../modules/uptime"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  target_wiki = "cloud-coffeebase.wikibase.cloud"
  target_wbaas_hostname = "wikibase.cloud"

  wikibase_itempage_item = "Q1"
  wikibase_itempage_content = "I like coffee"

  project_id = local.project_id
}