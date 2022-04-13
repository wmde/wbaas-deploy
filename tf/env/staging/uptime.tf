module "uptime-checks" {
  source = "./../../modules/uptime"
  providers = {
    kubernetes = kubernetes.wbaas-2
  }
  target_wiki = "coffeebase.wikibase.dev"
  target_wbaas_hostname = "wikibase.dev"
  project_id = local.project_id
}