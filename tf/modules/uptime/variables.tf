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

variable "monitoring_email_group_name" {
  type = string
  description = "Name of the monitoring resource that will receive alerts"
}

variable "wikibase_itempage_item" {
  type = string
  description = "The target item we will check. Example: Q1"
  default = "Q1"
}

variable "wikibase_itempage_content" {
  type = string
  description = "The content we look for rendered when visiting `wikibase_itempage_item_id`."
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
      matcher = "CONTAINS_STRING"
    },
    "https-www-${local.target_wbaas_name}-api-health" = {
      name          = "https-www-${local.target_wbaas_name}-api-health"
      host          = "api.${var.target_wbaas_hostname}"
      path          = "/healthz"
      content      = "It's Alive"
      matcher = "CONTAINS_STRING"
    },

    /* WIKI CHECKS */
    "https-${local.target_name}" = {
      name          = "https-${local.target_name}"
      host          = var.target_wiki
      path          = "/wiki/Special:Version"
      content      = "Adam Shorland"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-query" = {
      name          = "https-${local.target_name}-query"
      host          = var.target_wiki
      path          = "/query"
      content      = "Special:MyLanguage/Wikidata:SPARQL_query_service"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-query-sparql" = {
      name          = "https-${local.target_name}-query-sparql"
      host          = var.target_wiki
      path          = "/query/sparql"
      content      = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-cradle" = {
      name          = "https-${local.target_name}-cradle"
      host          = var.target_wiki
      path          = "/tools/cradle"
      content      = "<script src=\"vue.js\"></script>"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-quickstatements" = {
      name          = "https-${local.target_name}-quickstatements"
      host          = var.target_wiki
      path          = "/tools/quickstatements"
      content      = "magnusmanske"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-widar" = {
      name          = "https-${local.target_name}-widar"
      host          = var.target_wiki
      path          = "/tools/widar"
      content      = "You have not authorized Widar"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-wikibase-wbgetentities" = {
      name          = "https-${local.target_name}-wikibase-wbgetentities"
      host          = var.target_wiki
      path          = "/w/api.php?action=wbgetentities&format=json&errorformat=plaintext&uselang=en&ids=${var.wikibase_itempage_item}"
      content      = "${var.wikibase_itempage_content}"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-wikibase-itempage" = {
      name          = "https-${local.target_name}-wikibase-itempage"
      host          = var.target_wiki
      path          = "/wiki/Item:${var.wikibase_itempage_item}"
      content      = "${var.wikibase_itempage_content}"
      matcher = "CONTAINS_STRING"
    },
    "https-${local.target_name}-wikibase-cirrussearch" = {
      name          = "https-${local.target_name}-wikibase-cirrussearch"
      host          = var.target_wiki
      path          = "/w/api.php?action=cirrus-mapping-dump&format=json"
      matcher       = "NOT_MATCHES_JSON_PATH"
      json_matcher     = "REGEX_MATCH"
      json_path  = "$.error"
      content = ".*"
    },
  }
}