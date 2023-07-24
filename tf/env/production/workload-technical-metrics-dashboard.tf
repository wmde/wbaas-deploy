resource "google_monitoring_dashboard" "workload-technical-metrics" {
    dashboard_json = jsonencode(
        {
            displayName  = "Workload technical metrics (Production)"
            labels       = {
                production = ""
            }
            mosaicLayout = {
                columns = 12
                tiles   = [
                    {
                        height = 3
                        widget = {
                            title   = "Mediawiki - Max CPU Limit Utilization"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_MAX"
                                                    groupByFields      = [
                                                        "metadata.user_labels.\"app.kubernetes.io/component\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MAX"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"default\" resource.label.\"cluster_name\"=\"wbaas-3\" resource.label.\"container_name\"=\"mediawiki\""
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
                        height = 3
                        widget = {
                            title   = "API - Memory Limit Utilization "
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_MEAN"
                                                    groupByFields      = [
                                                        "resource.label.\"container_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MAX"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=monitoring.regex.full_match(\"(api-\\\\w+)\") resource.label.\"cluster_name\"=\"wbaas-3\""
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
                        yPos   = 7
                    },
                    {
                        height = 3
                        widget = {
                            title   = "SQL/Redis/ElasticSearch/Queryservice - Max Memory Limit Utilization "
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation          = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_MAX"
                                                    groupByFields      = [
                                                        "resource.label.\"pod_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MAX"
                                                }
                                                filter               = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=monitoring.regex.full_match(\"mariadb|elasticsearch|redis|queryservice\") resource.label.\"cluster_name\"=\"wbaas-3\""
                                                secondaryAggregation = {
                                                    alignmentPeriod = "60s"
                                                }
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
                        yPos   = 10
                    },
                    {
                        height = 3
                        widget = {
                            title   = "SQL/Redis/ElasticSearch/Queryservice - Max Cpu Limit Utilization "
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_MAX"
                                                    groupByFields      = [
                                                        "resource.label.\"pod_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MAX"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=monitoring.regex.full_match(\"mariadb|elasticsearch|redis|queryservice\") resource.label.\"cluster_name\"=\"wbaas-3\""
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
                        yPos   = 10
                    },
                    {
                        height = 4
                        widget = {
                            title   = "logging/user/production-site-request-count (filtered) [SUM]"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    groupByFields      = [
                                                        "metric.label.\"domain\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-site-request-count\" metric.label.\"domain\"!=monitoring.regex.full_match(\".+.wikibase.dev\")"
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
                        width  = 12
                    },
                    {
                        height = 3
                        widget = {
                            title   = "Mediawiki - Max Memory Limit Utilization"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_MAX"
                                                    groupByFields      = [
                                                        "metadata.user_labels.\"app.kubernetes.io/component\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MAX"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"default\" resource.label.\"cluster_name\"=\"wbaas-3\" resource.label.\"container_name\"=\"mediawiki\""
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
                        height = 3
                        widget = {
                            title   = "API - Max CPU Limit Utilization "
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_MAX"
                                                    groupByFields      = [
                                                        "resource.label.\"container_name\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MAX"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=monitoring.regex.full_match(\"(api-\\\\w+)\") resource.label.\"cluster_name\"=\"wbaas-3\""
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
                        yPos   = 7
                    },
                ]
            }
            name         = "projects/658442145969/dashboards/97f8c476-bedc-448e-b118-4916197dab0d"
        }
    )
    project        = "wikibase-cloud"

    timeouts {}
}
