resource "google_monitoring_dashboard" "incoming-traffic" {
    dashboard_json = jsonencode(
        {
            displayName  = "Incoming Traffic"
            mosaicLayout = {
                columns = 12
                tiles   = [
                    {
                        height = 4
                        widget = {
                            title   = "Incoming Requests"
                            xyChart = {
                                dataSets          = [
                                    {
                                        minAlignmentPeriod = "60s"
                                        plotType           = "LINE"
                                        targetAxis         = "Y1"
                                        timeSeriesQuery    = {
                                            timeSeriesFilter = {
                                                aggregation = {
                                                    alignmentPeriod  = "60s"
                                                    perSeriesAligner = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-site-request-count\""
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
                            title   = "Incoming requests by domain"
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
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-site-request-count\""
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
                            title   = "Incoming requests by httpMethod"
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
                                                        "metric.label.\"httpMethod\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-site-request-count\""
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
                            title   = "internal server error (5XX) response count"
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
                                                        "metric.label.\"statuscode\"",
                                                    ]
                                                    perSeriesAligner   = "ALIGN_RATE"
                                                }
                                                filter      = "metric.type=\"logging.googleapis.com/user/production-site-request-count\" metric.label.\"statuscode\"=monitoring.regex.full_match(\"5\\\\d+\")"
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
            name         = "projects/658442145969/dashboards/3f8a9d3f-bd6a-450d-ab75-b3c6361bc321"
        }
    )
    project        = "wikibase-cloud"

    timeouts {}    
}
