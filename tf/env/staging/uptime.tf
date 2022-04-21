module "uptime-checks" {
  source = "./../../modules/uptime"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  target_wiki = "coffeebase.wikibase.dev"
  target_wbaas_hostname = "wikibase.dev"

  wikibase_itempage_item = "Q1"
  wikibase_itempage_content = "Arabica"

  project_id = local.project_id
}