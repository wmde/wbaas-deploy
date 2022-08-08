resource "google_logging_metric" "platform-summary-metrics" {
    for_each = var.platform_summary_metrics

    filter           = <<-EOT
        resource.type="k8s_container"
        resource.labels.cluster_name="${var.cluster_name}"
        resource.labels.namespace_name="default"
        labels.k8s-pod/app_kubernetes_io/component="queue"
        labels.k8s-pod/app_kubernetes_io/instance="api"
        labels.k8s-pod/app_kubernetes_io/name="api" severity>=DEFAULT
        jsonPayload.platform_summary_version="v1"
    EOT
    name             = "${var.cluster_name}-platform-summary-${each.value}"
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

    }

    timeouts {}
}