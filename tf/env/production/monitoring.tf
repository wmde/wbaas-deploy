module "production-monitoring" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/monitoring?ref=tf-module-monitoring-7"
  
  providers = {
    kubernetes = kubernetes.wbaas-3
  }

  cluster_name = local.production_cluster_name
  email_group = "wb-cloud-monitoring@wikimedia.de"
}

resource "google_logging_metric" "production-site-request-count" {
    description      = "Count of requests to sites"
    filter           = <<-EOT
        resource.labels.container_name="nginx-ingress-controller"
        resource.type="k8s_container"
        -textPayload:"GoogleStackdriverMonitoring"
        -textPayload:"cert-manager"
        -textPayload:"Widar"
    EOT
    label_extractors = {
        "domain"     = "REGEXP_EXTRACT(textPayload, \"\\\\w+ https:\\\\/\\\\/([^\\\\/]+)\")"
        "httpMethod" = "REGEXP_EXTRACT(textPayload, \"(\\\\w+) https:\\\\/\\\\/[^ ]+ [^ ]+ \\\\d+\")"
        "statuscode" = "REGEXP_EXTRACT(textPayload, \"\\\\w+ https:\\\\/\\\\/[^ ]+ [^ ]+ (\\\\d+)\")"
    }
    name             = "production-site-request-count"
    project          = "wikibase-cloud"

    metric_descriptor {
        metric_kind = "DELTA"
        unit        = "1"
        value_type  = "INT64"

        labels {
            key        = "domain"
            value_type = "STRING"
        }
        labels {
            key        = "httpMethod"
            value_type = "STRING"
        }
        labels {
            key        = "statuscode"
            value_type = "STRING"
        }
    }
}
