resource "google_monitoring_dashboard" "elasticsearch-monitoring" {
    dashboard_json = jsonencode(
        {
            displayName  = "Elasticsearch Monitoring"
            mosaicLayout = {
                columns = 12
                tiles   = [
                    {
                        height = 4
                        widget = {
                            title   = "Time spent running GC"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
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
                                                    perSeriesAligner   = "ALIGN_PERCENTILE_99"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-es-gc-time-mins\""
                                            }
                                        }
                                    },
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    perSeriesAligner   = "ALIGN_PERCENTILE_99"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-es-gc-time-seconds\""
                                            }
                                        }
                                    },
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod    = "60s"
                                                    crossSeriesReducer = "REDUCE_SUM"
                                                    perSeriesAligner   = "ALIGN_PERCENTILE_99"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-es-gc-time-ms\""
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
                            title   = "GC Warning Count"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation          = {
                                                    alignmentPeriod  = "60s"
                                                    perSeriesAligner = "ALIGN_RATE"
                                                }
                                                filter               = "metric.type=\"logging.googleapis.com/user/elasticsearch-concerning-gc-count\" metric.label.\"Cluster\"=\"wbaas-3\""
                                                secondaryAggregation = {
                                                    alignmentPeriod  = "60s"
                                                    perSeriesAligner = "ALIGN_MEAN"
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
                    },
                    {
                        height = 4
                        widget = {
                            title   = "logging/user/elasticsearch-metrics-heap.percent [99TH PERCENTILE]"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation          = {
                                                    alignmentPeriod  = "60s"
                                                    perSeriesAligner = "ALIGN_PERCENTILE_99"
                                                }
                                                filter               = "metric.type=\"logging.googleapis.com/user/elasticsearch-metrics-heap.percent\""
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
                        yPos   = 4
                    },
                ]
            }
            name         = "projects/658442145969/dashboards/42950a88-c6da-4cf8-be04-2cb5a1ab4413"
        }
    )
    project        = "wikibase-cloud"

    timeouts {}
}