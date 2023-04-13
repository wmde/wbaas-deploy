# google_monitoring_dashboard.elasticsearch-prometheus:
resource "google_monitoring_dashboard" "elasticsearch-prometheus" {
    dashboard_json = jsonencode(
        {
            dashboardFilters = [
                {
                    filterType       = "RESOURCE_LABEL"
                    labelKey         = "cluster"
                    stringValue      = "wbaas-3"
                    templateVariable = "Cluster"
                },
                {
                    filterType       = "RESOURCE_LABEL"
                    labelKey         = "location"
                    templateVariable = "Location"
                },
                {
                    filterType       = "RESOURCE_LABEL"
                    labelKey         = "namespace"
                    templateVariable = "Namespace"
                },
            ]
            displayName      = "Elasticsearch Prometheus Overview – Cluster filtering hardcoded"
            etag             = "c011e864ee38f669856ee1575ec41939"
            mosaicLayout     = {
                columns = 12
                tiles   = [
                    {
                        height = 3
                        widget = {
                            timeSeriesTable = {
                                dataSets            = [
                                    {
                                        minAlignmentPeriod = "0s"
                                        timeSeriesQuery    = {
                                            prometheusQuery = "elasticsearch_cluster_health_status{$${Cluster},$${Location},$${Namespace}}"
                                        }
                                    },
                                ]
                                metricVisualization = "NUMBER"
                            }
                            title           = "Cluster Health"
                        }
                        width  = 6
                        yPos   = 2
                    },
                    {
                        height = 2
                        widget = {
                            scorecard = {
                                gaugeView       = {
                                    upperBound = 100
                                }
                                thresholds      = [
                                    {
                                        color     = "RED"
                                        direction = "ABOVE"
                                        value     = 50
                                    },
                                    {
                                        color     = "YELLOW"
                                        direction = "ABOVE"
                                        value     = 30
                                    },
                                ]
                                timeSeriesQuery = {
                                    prometheusQuery = "count(elasticsearch_breakers_tripped{$${Cluster},$${Location},$${Namespace}})"
                                }
                            }
                            title     = "Tripped Breakers"
                        }
                        width  = 2
                    },
                    {
                        height = 2
                        widget = {
                            scorecard = {
                                gaugeView       = {
                                    upperBound = 100
                                }
                                thresholds      = [
                                    {
                                        color     = "RED"
                                        direction = "ABOVE"
                                        value     = 80
                                    },
                                    {
                                        color     = "YELLOW"
                                        direction = "ABOVE"
                                        value     = 50
                                    },
                                ]
                                timeSeriesQuery = {
                                    prometheusQuery = "sum (elasticsearch_process_cpu_percent{$${Cluster},$${Location},$${Namespace}} ) / count (elasticsearch_process_cpu_percent{$${Cluster},$${Location},$${Namespace}} )"
                                }
                            }
                            title     = "CPU Avg Usage %"
                        }
                        width  = 2
                        xPos   = 2
                    },
                    {
                        height = 2
                        widget = {
                            scorecard = {
                                gaugeView       = {
                                    upperBound = 100
                                }
                                thresholds      = [
                                    {
                                        color     = "RED"
                                        direction = "ABOVE"
                                        value     = 80
                                    },
                                    {
                                        color     = "YELLOW"
                                        direction = "ABOVE"
                                        value     = 50
                                    },
                                ]
                                timeSeriesQuery = {
                                    prometheusQuery = "avg(elasticsearch_jvm_memory_used_bytes{$${Cluster},$${Location},$${Namespace}} / elasticsearch_jvm_memory_max_bytes{$${Cluster},$${Location},$${Namespace}} * 100)"
                                }
                            }
                            title     = "JVM Memory Avg Usage %"
                        }
                        width  = 2
                        xPos   = 4
                    },
                    {
                        height = 2
                        widget = {
                            scorecard = {
                                timeSeriesQuery = {
                                    prometheusQuery = "sum(elasticsearch_cluster_health_number_of_nodes{$${Cluster},$${Location},$${Namespace}})"
                                }
                            }
                            title     = "ES Nodes"
                        }
                        width  = 2
                        xPos   = 6
                    },
                    {
                        height = 2
                        widget = {
                            scorecard = {
                                timeSeriesQuery = {
                                    prometheusQuery = "sum(elasticsearch_cluster_health_number_of_data_nodes{$${Cluster},$${Location},$${Namespace}})"
                                }
                            }
                            title     = "ES Data Nodes"
                        }
                        width  = 2
                        xPos   = 8
                    },
                    {
                        height = 2
                        widget = {
                            scorecard = {
                                timeSeriesQuery = {
                                    prometheusQuery = "sum(elasticsearch_cluster_health_number_of_pending_tasks{$${Cluster},$${Location},$${Namespace}})"
                                }
                            }
                            title     = "Pending Tasks"
                        }
                        width  = 2
                        xPos   = 10
                    },
                    {
                        height = 3
                        widget = {
                            timeSeriesTable = {
                                dataSets            = [
                                    {
                                        minAlignmentPeriod = "0s"
                                        timeSeriesQuery    = {
                                            prometheusQuery = "elasticsearch_process_open_files_count{$${Cluster},$${Location},$${Namespace}}"
                                        }
                                    },
                                ]
                                metricVisualization = "NUMBER"
                            }
                            title           = "Open file descriptors"
                        }
                        width  = 6
                        xPos   = 6
                        yPos   = 2
                    },
                    {
                        height = 4
                        widget = {
                            title   = "OS Load Average over 15min"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "elasticsearch_os_load15{$${Cluster},$${Location},$${Namespace}}"
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 4
                        yPos   = 5
                    },
                    {
                        height = 4
                        widget = {
                            title   = "CPU Usage % "
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "elasticsearch_process_cpu_percent{$${Cluster},$${Location},$${Namespace}}"
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 4
                        xPos   = 4
                        yPos   = 5
                    },
                    {
                        height = 4
                        widget = {
                            title   = "JVM Memory Pool Peak Used Bytes"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "elasticsearch_jvm_memory_pool_peak_used_bytes{$${Cluster},$${Location},$${Namespace}}"
                                        }
                                    },
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "elasticsearch_jvm_memory_max_bytes{$${Cluster},$${Location},$${Namespace}}"
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 4
                        xPos   = 8
                        yPos   = 5
                    },
                    {
                        height = 4
                        widget = {
                            title   = "Disk Usage %"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "100 * (1-(elasticsearch_filesystem_data_available_bytes{$${Cluster},$${Location},$${Namespace}}/elasticsearch_filesystem_data_size_bytes{$${Cluster},$${Location},$${Namespace}}))"
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 4
                        yPos   = 9
                    },
                    {
                        height = 4
                        widget = {
                            title   = "Network Usage"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "irate(elasticsearch_transport_rx_size_bytes_total{$${Cluster},$${Location},$${Namespace}}[5m])"
                                        }
                                    },
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "irate(elasticsearch_transport_tx_size_bytes_total{$${Cluster},$${Location},$${Namespace}}[5m])"
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 4
                        xPos   = 4
                        yPos   = 9
                    },
                    {
                        height = 4
                        widget = {
                            title   = "Thread Pool Operations Rejected"
                            xyChart = {
                                chartOptions      = {
                                    mode = "COLOR"
                                }
                                dataSets          = [
                                    {
                                        plotType        = "LINE"
                                        targetAxis      = "Y1"
                                        timeSeriesQuery = {
                                            prometheusQuery = "irate(elasticsearch_thread_pool_rejected_count{$${Cluster},$${Location},$${Namespace}}[5m])"
                                        }
                                    },
                                ]
                                timeshiftDuration = "0s"
                                yAxis             = {
                                    scale = "LINEAR"
                                }
                            }
                        }
                        width  = 4
                        xPos   = 8
                        yPos   = 9
                    },
                ]
            }
            name             = "projects/658442145969/dashboards/e771ea98-5c12-4b10-9c85-47d4abceaec7"
        }
    )
    project        = "658442145969"

    timeouts {}
}
