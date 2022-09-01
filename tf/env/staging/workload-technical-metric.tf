resource "google_monitoring_dashboard" "workload-technical-metrics" {
  dashboard_json = jsonencode(
    {
      displayName  = "Workload technical metrics (Staging)"
      labels       = {
        staging = ""
      }
      mosaicLayout = {
        columns = 12
        tiles   = [
          {
            height = 4
            widget = {
              title   = "logging/user/staging-site-request-count (filtered) by label.domain [SUM]"
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
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_SUM"
                          groupByFields      = [
                            "metric.label.\"domain\"",
                          ]
                          perSeriesAligner   = "ALIGN_RATE"
                        }
                        filter               = "metric.type=\"logging.googleapis.com/user/staging-site-request-count\" metric.label.\"domain\"!=monitoring.regex.full_match(\".+.wikibase.cloud\")"
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
            width  = 12
          },
          {
            height = 4
            widget = {
              title   = "Mediawiki - Max CPU limit utilization "
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
                          crossSeriesReducer = "REDUCE_MAX"
                          groupByFields      = [
                            "metadata.user_labels.\"app.kubernetes.io/component\"",
                          ]
                          perSeriesAligner   = "ALIGN_MAX"
                        }
                        filter      = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=\"wbaas-2\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=\"mediawiki\""
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
              title   = "Mediawiki - Max Memory limit utilization "
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
                          crossSeriesReducer = "REDUCE_MAX"
                          groupByFields      = [
                            "metadata.user_labels.\"app.kubernetes.io/component\"",
                          ]
                          perSeriesAligner   = "ALIGN_MAX"
                        }
                        filter      = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=\"wbaas-2\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=\"mediawiki\""
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
              title   = "API - Max CPU limit utilization"
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
                          crossSeriesReducer = "REDUCE_MAX"
                          groupByFields      = [
                            "resource.label.\"container_name\"",
                          ]
                          perSeriesAligner   = "ALIGN_MAX"
                        }
                        filter      = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=\"wbaas-2\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=monitoring.regex.full_match(\"(api-\\\\w+)\")"
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
              title   = "APi - Memory limit utilization "
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
                          crossSeriesReducer = "REDUCE_MAX"
                          groupByFields      = [
                            "resource.label.\"container_name\"",
                          ]
                          perSeriesAligner   = "ALIGN_MAX"
                        }
                        filter      = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=\"wbaas-2\" resource.label.\"namespace_name\"=\"default\" resource.label.\"container_name\"=monitoring.regex.full_match(\"(api-\\\\w+)\")"
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
              title   = "SQL/Redis/ElasticSearch/Queryservice - Max CPU limit utilization "
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
                          crossSeriesReducer = "REDUCE_MAX"
                          groupByFields      = [
                            "resource.label.\"pod_name\"",
                          ]
                          perSeriesAligner   = "ALIGN_MAX"
                        }
                        filter      = "metric.type=\"kubernetes.io/container/cpu/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"cluster_name\"=\"wbaas-2\" resource.label.\"container_name\"=monitoring.regex.full_match(\"mariadb|elasticsearch|redis|queryservice\") resource.label.\"namespace_name\"=\"default\""
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
              title   = "SQL/Redis/ElasticSearch/Queryservice - Max Memory Limit Utilization "
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
                          crossSeriesReducer = "REDUCE_MAX"
                          groupByFields      = [
                            "resource.label.\"pod_name\"",
                          ]
                          perSeriesAligner   = "ALIGN_MAX"
                        }
                        filter      = "metric.type=\"kubernetes.io/container/memory/limit_utilization\" resource.type=\"k8s_container\" resource.label.\"namespace_name\"=\"default\" resource.label.\"cluster_name\"=\"wbaas-2\" resource.label.\"container_name\"=monitoring.regex.full_match(\"mariadb|elasticsearch|redis|queryservice\")"
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
        ]
      }
      name         = "projects/658442145969/dashboards/2d52c0cf-9699-4758-a013-d25bfe771213"
    }
  )
  project        = "wikibase-cloud"

  timeouts {}
}
