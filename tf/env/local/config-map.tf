module "wbaas-config" {
  source = "./../../modules/config-map/wbaas-ui-config"
  
  cname_record = "sites-1.dyna.wbaas.localhost."
}

module "wbaas-mediawiki-config" {
  source = "./../../modules/config-map/wbaas-mediawiki-config"

  wikibase_concept_uri_scheme = "http://"
}

