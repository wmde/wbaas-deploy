module "production-monitoring" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/monitoring?ref=tf-module-monitoring-18"

  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  environment                 = "production"
  cluster_name                = local.production_cluster_name
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
  platform_summary_metrics = toset([
    "active",
    "total",
    "deleted",
    "inactive",
    "empty",
    "total_non_deleted_users",
    "total_non_deleted_active_users",
    "total_non_deleted_pages",
    "total_non_deleted_edits",
    "wikis_created_PT24H",
    "wikis_created_P30D",
    "users_created_PT24H",
    "users_created_P30D",
  ])
}

resource "google_logging_metric" "production-site-request-count" {
  description = "Count of requests to sites"
  filter      = <<-EOT
        labels."k8s-pod/app_kubernetes_io/name"="ingress-nginx"
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
  name    = "production-site-request-count"
  project = "wikibase-cloud"

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
