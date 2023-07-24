resource "google_monitoring_dashboard" "volume-utilisation" {
    dashboard_json = jsonencode(
        {
            displayName  = "Volume Utilisation"
            mosaicLayout = {
                columns = 12
                tiles   = [
                    {
                        height = 4
                        widget = {
                            title   = "Production QueryService"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "300s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "300s"
                                                    crossSeriesReducer = "REDUCE_MEAN"
                                                    perSeriesAligner   = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/pod/volume/utilization\" resource.type=\"k8s_pod\" resource.label.\"cluster_name\"=\"wbaas-3\" metadata.user_labels.\"app.kubernetes.io/instance\"=\"queryservice\" metric.label.\"volume_name\"=\"data\""
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
                    },
                    {
                        height = 4
                        widget = {
                            title   = "production sql"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "300s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod  = "300s"
                                                    perSeriesAligner = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/pod/volume/utilization\" resource.type=\"k8s_pod\" resource.label.\"cluster_name\"=\"wbaas-3\" metadata.user_labels.\"app.kubernetes.io/instance\"=\"sql\" metric.label.\"volume_name\"=\"data\""
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
                    },
                    {
                        height = 4
                        widget = {
                            title   = "Production Elasticsearch"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "300s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod  = "300s"
                                                    perSeriesAligner = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"kubernetes.io/pod/volume/utilization\" resource.type=\"k8s_pod\" resource.label.\"cluster_name\"=\"wbaas-3\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"elasticsearch-master-.+\") metric.label.\"volume_name\"=\"elasticsearch-master\""
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
                            title   = "sql-logic-backup scratch-disk space"
                            xyChart = {
                                dataSets          = [
                                    {
                                        legendTemplate  = "Used"
                                        plotType        = "STACKED_BAR"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            timeSeriesFilterRatio = {
                                                denominator = {
                                                    aggregation = {
                                                        alignmentPeriod    = "60s"
                                                        crossSeriesReducer = "REDUCE_SUM"
                                                        perSeriesAligner   = "ALIGN_MEAN"
                                                    }
                                                    filter      = "metric.type=\"kubernetes.io/pod/volume/total_bytes\" resource.type=\"k8s_pod\" resource.label.\"location\"=\"europe-west3-a\" resource.label.\"cluster_name\"=\"wbaas-3\" resource.label.\"namespace_name\"=\"default\" metadata.system_labels.\"top_level_controller_type\"=\"CronJob\" metadata.system_labels.\"top_level_controller_name\"=\"sql-logic-backup\""
                                                }
                                                numerator   = {
                                                    aggregation = {
                                                        alignmentPeriod    = "60s"
                                                        crossSeriesReducer = "REDUCE_SUM"
                                                        perSeriesAligner   = "ALIGN_MEAN"
                                                    }
                                                    filter      = "metric.type=\"kubernetes.io/pod/volume/used_bytes\" resource.type=\"k8s_pod\" resource.label.\"location\"=\"europe-west3-a\" resource.label.\"cluster_name\"=\"wbaas-3\" resource.label.\"namespace_name\"=\"default\" metadata.system_labels.\"top_level_controller_type\"=\"CronJob\" metadata.system_labels.\"top_level_controller_name\"=\"sql-logic-backup\""
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
                        yPos   = 4
                    },
                ]
            }
            name         = "projects/658442145969/dashboards/fd1bf4b9-3b5b-4cd0-9529-3f1f75c3bdbd"
        }
    )
    project        = "wikibase-cloud"

    timeouts {}
}
