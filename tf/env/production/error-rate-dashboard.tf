resource "google_monitoring_dashboard" "error-rate" {
    dashboard_json = jsonencode(
        {
            displayName  = "Error Rate (Production)"
            labels       = {
                production = ""
            }
            mosaicLayout = {
                columns = 12
                tiles   = [
                    {
                        height = 4
                        widget = {
                            title   = "api error-rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_BAR"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "resource.label.\"container_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"container_name\"=monitoring.regex.full_match(\"api-\\\\w+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        xPos   = 6
                        yPos   = 8
                    },
                    {
                        height = 4
                        widget = {
                            title   = "mediawiki pod error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_BAR"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "resource.label.\"pod_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"mediawiki-\\\\w+-\\\\w+-\\\\w+-\\\\w+-.+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        yPos   = 4
                    },
                    {
                        height = 4
                        widget = {
                            title   = "mediawiki error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_BAR"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "metadata.user_labels.\"app.kubernetes.io/component\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"mediawiki-\\\\w+-\\\\w+-\\\\w+-\\\\w+-.+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        xPos   = 6
                        yPos   = 4
                    },
                    {
                        height = 4
                        widget = {
                            title   = "queryservice error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_AREA"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "resource.label.\"container_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"queryservice-.+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        yPos   = 8
                    },
                    {
                        height = 4
                        widget = {
                            title   = "ingress-nginx-controller error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_BAR"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "resource.label.\"pod_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"ingress-nginx-controller-.+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        xPos   = 6
                        yPos   = 12
                    },
                    {
                        height = 4
                        widget = {
                            title   = "platform-nginx error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_BAR"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "resource.label.\"pod_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"platform-nginx-.+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        yPos   = 12
                    },
                    {
                        height = 4
                        widget = {
                            title   = "mariadb error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_BAR"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "resource.label.\"pod_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"sql-mariadb.+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        yPos   = 16
                    },
                    {
                        height = 4
                        widget = {
                            title   = "tool pod error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "STACKED_BAR"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "resource.label.\"pod_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"tool-\\\\w+-.+\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                            }
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        xPos   = 6
                        yPos   = 16
                    },
                    {
                        height = 4
                        widget = {
                            logsPanel = {
                                filter        = <<-EOT
                                    resource.labels.cluster_name="wbaas-3"
                                    severity=ERROR
                                    -"cert-manager"
                                EOT
                                resourceNames = [
                                    "projects/658442145969",
                                ]
                            }
                            title     = "Error logs (filtered)"
                        }
                        width  = 12
                    },
                    {
                        height = 4
                        widget = {
                            title   = "ui pod error rate"
                            xyChart = {
                                dataSets          = [
                                    {
                                        plotType        = "STACKED_BAR"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            timeSeriesQueryLanguage = <<-EOT
                                                fetch k8s_container
                                                | metric 'logging.googleapis.com/log_entry_count'
                                                | filter
                                                    (resource.cluster_name == 'wbaas-3' && resource.pod_name =~ 'ui-\\w+-\\w+')
                                                    && (metric.severity == 'ERROR')
                                                | align rate(1m)
                                                | every 1m
                                                | group_by [resource.pod_name],
                                                    [value_log_entry_count_aggregate: aggregate(value.log_entry_count)]
                                            EOT
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    label = "y1Axis"
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 6
                        yPos   = 20
                    },
                ]
            }
            name         = "projects/658442145969/dashboards/31b6e1c0-7d85-4ae3-b277-2ff3cb085875"
        }
    )
    project        = "wikibase-cloud"

    timeouts {}
}
