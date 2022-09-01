resource "google_monitoring_dashboard" "uptime-latency" {
    dashboard_json = jsonencode(
        {
            displayName  = "Uptime and Latency (Production)"
            labels       = {
                production = ""
            }
            mosaicLayout = {
                columns = 12
                tiles   = [
                    {
                        height = 4
                        widget = {
                            title   = "Request Latency of the platform API health endpoint"
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
                                                    crossSeriesReducer = "REDUCE_MEAN"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-www-wikibase-cloud-api-health\""
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
                            title   = "Request Latency of Mediawiki API"
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
                                                    crossSeriesReducer = "REDUCE_MEAN"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud-wikibase-wbgetentities\""
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
                            title   = "Request latency of Queryservice"
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
                                                    crossSeriesReducer = "REDUCE_MEAN"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud-query-sparql\""
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
                            title   = "Request latency of Mediawiki Web Pod - Item"
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
                                                    crossSeriesReducer = "REDUCE_MEAN"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud-wikibase-itempage\""
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
                            title   = "Request latency of Mediawiki Web Pod - Special:Version"
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
                                                    crossSeriesReducer = "REDUCE_MEAN"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_MEAN"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud\""
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
                            title   = "Count of \"down\" checks of Mediawiki API"
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
                                                    crossSeriesReducer = "REDUCE_COUNT_FALSE"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_NEXT_OLDER"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud-wikibase-wbgetentities\""
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
                            title   = "Count of \"down\" checks of The platform API health endpoint"
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
                                                    crossSeriesReducer = "REDUCE_COUNT_FALSE"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_NEXT_OLDER"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-www-wikibase-cloud-api-health\""
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
                            title   = "Count of \"down\" checks of Queryservice"
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
                                                    crossSeriesReducer = "REDUCE_COUNT_FALSE"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_NEXT_OLDER"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud-query-sparql\""
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
                            title   = "Count of \"down\" checks of Mediawiki Web Pod - Item"
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
                                                    crossSeriesReducer = "REDUCE_COUNT_FALSE"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_NEXT_OLDER"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud-wikibase-itempage\""
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
                            title   = "Count of \"down\" checks of Mediawiki Web Pod - Special:Version"
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
                                                    crossSeriesReducer = "REDUCE_COUNT_FALSE"
                                                    groupByFields      = [
                                                        "metric.label.\"check_id\"",
                                                        "metric.label.\"checker_location\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_NEXT_OLDER"
                                                }
                                                filter      = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-cloud-coffeebase-wikibase-cloud\""
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
                ]
            }
            name         = "projects/658442145969/dashboards/90f60aaf-56da-447b-b1ca-43520e5e07ee"
        }
    )
    project        = "wikibase-cloud"

    timeouts {}
}