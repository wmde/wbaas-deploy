module "wbaas-config" {
  source = "./../../modules/config-map/wbaas-config"
  
  cname_record = "sites-1.dyna.wikibase.dev."
}

