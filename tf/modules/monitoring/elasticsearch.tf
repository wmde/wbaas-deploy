resource "google_logging_metric" "elasticsearch-metrics" {
    for_each = var.elasticsearch_metrics

    filter           = <<-EOT
        resource.type="k8s_container"
        resource.labels.cluster_name="${var.cluster_name}"
        resource.labels.namespace_name="default"
        labels.k8s-pod/job-name:"stats-cron-" severity>=DEFAULT
    EOT
    label_extractors = {
        "Node" = "EXTRACT(jsonPayload.name)"
    }
    name             = "elasticsearch-metrics-${each.value}"
    value_extractor  = "REGEXP_EXTRACT(jsonPayload.\"${each.value}\", \"(\\\\d+)\")"

    bucket_options {

        exponential_buckets {
            growth_factor      = 2
            num_finite_buckets = 64
            scale              = 0.01
        }
    }

    metric_descriptor {
        metric_kind = "DELTA"
        unit        = "1"
        value_type  = "DISTRIBUTION"

        labels {
            key        = "Node"
            value_type = "STRING"
        }
    }

    timeouts {}
}