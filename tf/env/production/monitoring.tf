module "production-monitoring" {
  source = "../../modules/monitoring"
  providers = {
    kubernetes = kubernetes.wbaas-3
  }
  environment                 = "production"
  cluster_name                = local.production_cluster_name
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}

resource "google_logging_metric" "production-site-request-count" {
  description = "Count of requests to sites"
  filter      = <<-EOT
        labels."k8s-pod/app_kubernetes_io/name"="ingress-nginx"
        resource.type="k8s_container"
        textPayload=~"^\d*\.\d*\.\d*\.\d*\ - (-|\w) \["
        resource.labels.cluster_name="wbaas-3"
    EOT
  label_extractors = {
    "domain"     = "REGEXP_EXTRACT(textPayload, \"^(?:[0-9\\\\.]+) - - \\\\[[^\\\\]]+\\\\] \\\\\\\"(?:GET|POST|PUT|DELETE|HEAD|OPTIONS|PATCH) https?:\\\\/\\\\/([^\\\\/\\\\s]+)[^\\\\\\\"]*\\\\\\\" \\\\d{3}\")"
    "httpMethod" = "REGEXP_EXTRACT(textPayload, \"^(?:[0-9\\\\.]+) - - \\\\[[^\\\\]]+\\\\] \\\\\\\"(GET|POST|PUT|DELETE|HEAD|OPTIONS|PATCH) https?:\\\\/\\\\/[^\\\\/\\\\s]+[^\\\\\\\"]*\\\\\\\" \\\\d{3}\")"
    "statuscode" = "REGEXP_EXTRACT(textPayload, \"^(?:[0-9\\\\.]+) - - \\\\[[^\\\\]]+\\\\] \\\\\\\"(?:GET|POST|PUT|DELETE|HEAD|OPTIONS|PATCH) https?:\\\\/\\\\/[^\\\\/\\\\s]+[^\\\\\\\"]*\\\\\\\" (\\\\d{3})\")"
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
