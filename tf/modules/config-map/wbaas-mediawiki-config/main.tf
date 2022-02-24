resource "kubernetes_config_map" "wbaas-mediawiki" {
  metadata {
    name = "wbaas-mediawiki-config"
  }

  data = {
    wikibase_concept_uri_scheme = var.wikibase_concept_uri_scheme
  }

}

output "wikibase_concept_uri_scheme" {  value = var.wikibase_concept_uri_scheme }