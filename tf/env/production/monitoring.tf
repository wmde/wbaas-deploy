module "production-monitoring" {
  source = "git::ssh://git@github.com/wmde/wbaas-deploy//tf//modules/monitoring?ref=tf-module-monitoring-15"
  
  providers = {
    kubernetes = kubernetes.wbaas-3
  }

  cluster_name = local.production_cluster_name
  monitoring_email_group_name = google_monitoring_notification_channel.monitoring_email_group.name
}

resource "google_logging_metric" "production-es-gc-time-mins" {
    filter           = <<-EOT
        resource.type="k8s_container"
        resource.labels.project_id="wikibase-cloud"
        resource.labels.location="europe-west3-a"
        resource.labels.cluster_name="wbaas-3"
        resource.labels.namespace_name="default"
        labels.k8s-pod/app="elasticsearch-master" severity>=DEFAULT
        textPayload:"o.e.m.j.JvmGcMonitorService"
        textPayload:"[INFO ]"
    EOT
    label_extractors = {}
    name             = "production-es-gc-time-mins"
    project          = "wikibase-cloud"
    value_extractor  = "REGEXP_EXTRACT(textPayload, \"duration \\\\[(\\\\d+\\\\.?\\\\d*||\\\\.\\\\d+)m\\\\]\")"

    bucket_options {

        exponential_buckets {
            growth_factor      = 2
            num_finite_buckets = 64
            scale              = 0.01
        }
    }

    metric_descriptor {
        metric_kind = "DELTA"
        unit        = "min"
        value_type  = "DISTRIBUTION"
    }

    timeouts {}
}

resource "google_logging_metric" "production-es-gc-time-ms" {
    filter           = <<-EOT
        resource.type="k8s_container"
        resource.labels.project_id="wikibase-cloud"
        resource.labels.location="europe-west3-a"
        resource.labels.cluster_name="wbaas-3"
        resource.labels.namespace_name="default"
        labels.k8s-pod/app="elasticsearch-master" severity>=DEFAULT
        textPayload:"o.e.m.j.JvmGcMonitorService"
        textPayload:"[INFO ]"
    EOT
    label_extractors = {}
    name             = "production-es-gc-time-ms"
    project          = "wikibase-cloud"
    value_extractor  = "REGEXP_EXTRACT(textPayload, \"overhead, spent \\\\[(\\\\d+\\\\.?\\\\d*||\\\\.\\\\d+)ms\\\\]\")"

    bucket_options {

        exponential_buckets {
            growth_factor      = 2
            num_finite_buckets = 64
            scale              = 0.01
        }
    }

    metric_descriptor {
        metric_kind = "DELTA"
        unit        = "ms"
        value_type  = "DISTRIBUTION"
    }

    timeouts {}
}

resource "google_logging_metric" "production-es-gc-time-seconds" {
    filter           = <<-EOT
        resource.type="k8s_container"
        resource.labels.project_id="wikibase-cloud"
        resource.labels.location="europe-west3-a"
        resource.labels.cluster_name="wbaas-3"
        resource.labels.namespace_name="default"
        labels.k8s-pod/app="elasticsearch-master" severity>=DEFAULT
        textPayload:"o.e.m.j.JvmGcMonitorService"
        textPayload:"[INFO ]"
    EOT
    label_extractors = {}
    name             = "production-es-gc-time-seconds"
    project          = "wikibase-cloud"
    value_extractor  = "REGEXP_EXTRACT(textPayload, \"duration \\\\[(\\\\d+\\\\.?\\\\d*||\\\\.\\\\d+)s\\\\]\")"

    bucket_options {

        exponential_buckets {
            growth_factor      = 2
            num_finite_buckets = 64
            scale              = 0.01
        }
    }

    metric_descriptor {
        metric_kind = "DELTA"
        unit        = "s"
        value_type  = "DISTRIBUTION"
    }

    timeouts {}
}

resource "google_logging_metric" "production-site-request-count" {
    description      = "Count of requests to sites"
    filter           = <<-EOT
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
