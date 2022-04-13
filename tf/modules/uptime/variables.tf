variable "project_id" {
  type = string
  description = "Google project id. Example: wikibase-cloud"
}

variable "target_wiki" {
  type = string
  description = "The wiki we do uptime checks against. Manually created. Example: coffeebase.wikibase.dev"
}

variable "target_wbaas_hostname" {
  type = string
  description = "The target wbaas service we check uptime against. Example: wikibase.dev"
}

locals {
  target_name = replace(var.target_wiki, ".", "-")
  target_wbaas_name = replace(var.target_wbaas_hostname, ".", "-")

  checks = {
    /* API CHECKS */
    "https-www-${local.target_wbaas_name}" = {
      name          = "https-www-${local.target_wbaas_name}"
      host          = "www.${var.target_wbaas_hostname}"
      path          = "/"
      content      = "doesn't work properly without JavaScript enabled"
    },
    "https-www-${local.target_wbaas_name}-api-health" = {
      name          = "https-www-${local.target_wbaas_name}-api-health"
      host          = "api.${var.target_wbaas_hostname}"
      path          = "/healthz"
      content      = "It's Alive"
    },

    /* WIKI CHECKS */
    "https-${local.target_name}" = {
      name          = "https-${local.target_name}"
      host          = var.target_wiki
      path          = "/wiki/Special:Version"
      content      = "Adam Shorland"
    },
    "https-${local.target_name}-query" = {
      name          = "https-${local.target_name}-query"
      host          = var.target_wiki
      path          = "/query"
      content      = "Special:MyLanguage/Wikidata:SPARQL_query_service"
    },
    "https-${local.target_name}-query-sparql" = {
      name          = "https-${local.target_name}-query-sparql"
      host          = var.target_wiki
      path          = "/query/sparql"
      content      = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
    },
    "https-${local.target_name}-cradle" = {
      name          = "https-${local.target_name}-cradle"
      host          = var.target_wiki
      path          = "/tools/cradle"
      content      = "<script src=\"vue.js\"></script>"
    },
    "https-${local.target_name}-quickstatements" = {
      name          = "https-${local.target_name}-quickstatements"
      host          = var.target_wiki
      path          = "/tools/quickstatements"
      content      = "magnusmanske"
    },
    "https-${local.target_name}-widar" = {
      name          = "https-${local.target_name}-widar"
      host          = var.target_wiki
      path          = "/tools/widar"
      content      = "You have not authorized Widar"
    },
    "https-${local.target_name}-wikibase-wbgetentities" = {
      name          = "https-${local.target_name}-wikibase-wbgetentities"
      host          = var.target_wiki
      path          = "/w/api.php?action=wbgetentities&format=json&errorformat=plaintext&uselang=en&ids=Q1"
      content      = "success\":1"
    },
    "https-${local.target_name}-wikibase-itempage" = {
      name          = "https-${local.target_name}-wikibase-itempage"
      host          = var.target_wiki
      path          = "/wiki/Item:Q1"
      content      = "I like coffee"
    }
  }
}