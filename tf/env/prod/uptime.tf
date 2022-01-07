variable "update_checks" {
  description = "List of uptime checks to apply."
  type        = map(object({
    name          = string
    host = string
    path  = string
    content      = string
  }))
  default = {
  "https-www-wikibase-dev" = {
    name          = "https-www-wikibase-dev"
    host          = "www.wikibase.dev"
    path          = "/"
    content      = "doesn't work properly without JavaScript enabled"
  },
  # TODO make a health endpoint before adding a check
  # "https-www-wikibase-dev-api-health" = {
  #   name          = "https-www-wikibase-dev-api-health"
  #   host          = "www.wikibase.dev"
  #   path          = "/api/health"
  #   content      = "OK"
  # },
  "https-coffeebase-wikibase-dev" = {
    name          = "https-coffeebase-wikibase-dev"
    host          = "coffeebase.wikibase.dev"
    path          = "/wiki/Special:Version"
    content      = "Adam Shorland"
  },
  "https-coffeebase-wikibase-dev-query" = {
    name          = "https-coffeebase-wikibase-dev-query"
    host          = "coffeebase.wikibase.dev"
    path          = "/query"
    content      = "Special:MyLanguage/Wikidata:SPARQL_query_service"
  },
  "https-coffeebase-wikibase-dev-query-sparql" = {
    name          = "https-coffeebase-wikibase-dev-query-sparql"
    host          = "coffeebase.wikibase.dev"
    path          = "/query/sparql"
    content      = "http://www.w3.org/1999/02/22-rdf-syntax-ns"
  },
  "https-coffeebase-wikibase-dev-cradle" = {
    name          = "https-coffeebase-wikibase-dev-cradle"
    host          = "coffeebase.wikibase.dev"
    path          = "/tools/cradle"
    content      = "<script src=\"vue.js\"></script>"
  },
  "https-coffeebase-wikibase-dev-quickstatements" = {
    name          = "https-coffeebase-wikibase-dev-quickstatements"
    host          = "coffeebase.wikibase.dev"
    path          = "/tools/quickstatements"
    content      = "magnusmanske"
  },
  "https-coffeebase-wikibase-dev-widar" = {
    name          = "https-coffeebase-wikibase-dev-widar"
    host          = "coffeebase.wikibase.dev"
    path          = "/tools/widar"
    content      = "You have not authorized Widar"
  }
}
}

resource "google_monitoring_uptime_check_config" "https-content-uptime-check" {
  for_each = var.update_checks

  display_name = each.value.name
  timeout = "60s"

  http_check {
    path = each.value.path
    port = "443"
    use_ssl = true
    validate_ssl = true
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      host = each.value.host
    }
  }

  content_matchers {
    content = each.value.content
  }
}