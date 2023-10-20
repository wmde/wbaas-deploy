resource "google_monitoring_dashboard" "uptime-latency" {
  dashboard_json = jsonencode(
    {
      displayName = "Uptime and Latency (Staging)"
      labels = {
        staging = ""
      }
      mosaicLayout = {
        columns = 12
        tiles = [
          {
            height = 4
            widget = {
              title = "Request latency of the platform API health"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_MEAN"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-www-wikibase-dev-api-health-HJMz2B61RxQ\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            xPos  = 6
          },
          {
            height = 4
            widget = {
              title = "Request Latency of Queryservice"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_MEAN"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-query-sparql-ckVjQhmXqDg\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            yPos  = 4
          },
          {
            height = 4
            widget = {
              title = "Request latency of Mediawiki API"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_MEAN"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-wikibase-wbgetentities-ADerz9_UmdY\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
          },
          {
            height = 4
            widget = {
              title = "Request latency of Mediawiki Web Pod - Item"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_MEAN"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-wikibase-itempage-NRffch1fFzI\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            xPos  = 6
            yPos  = 4
          },
          {
            height = 4
            widget = {
              title = "Request latency of Special Version"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_MEAN"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/request_latency\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-7AbaoNv-B3U\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            yPos  = 8
          },
          {
            height = 4
            widget = {
              title = "Count of \"down\" checks of Mediawiki API"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_COUNT_FALSE"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_NEXT_OLDER"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-wikibase-wbgetentities-ADerz9_UmdY\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            xPos  = 6
            yPos  = 8
          },
          {
            height = 4
            widget = {
              title = "Count of \"down\" checks of The platform API health endpoint"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_COUNT_FALSE"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_NEXT_OLDER"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-www-wikibase-dev-api-health-HJMz2B61RxQ\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            yPos  = 12
          },
          {
            height = 4
            widget = {
              title = "Count of \"down\" checks of Queryservice"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_COUNT_FALSE"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_NEXT_OLDER"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-query-sparql-ckVjQhmXqDg\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            xPos  = 6
            yPos  = 12
          },
          {
            height = 4
            widget = {
              title = "Count of \"down\" checks of Mediawiki Web Pod - Item"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_COUNT_FALSE"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_NEXT_OLDER"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-wikibase-itempage-NRffch1fFzI\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            yPos  = 16
          },
          {
            height = 4
            widget = {
              title = "Count of \"down\" checks of Mediawiki Web Pod - Special:Version"
              xyChart = {
                dataSets = [
                  {
                    minAlignmentPeriod = "60s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "60s"
                          crossSeriesReducer = "REDUCE_COUNT_FALSE"
                          groupByFields = [
                            "metric.label.\"check_id\"",
                            "metric.label.\"checker_location\"",
                          ]
                          perSeriesAligner = "ALIGN_NEXT_OLDER"
                        }
                        filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"https-coffeebase-wikibase-dev-7AbaoNv-B3U\""
                      }
                    }
                  },
                ]
                timeshiftDuration = "0s"
                yAxis = {
                  label = "y1Axis"
                  scale = "LINEAR"
                }
              }
            }
            width = 6
            xPos  = 6
            yPos  = 16
          },
        ]
      }
      name = "projects/658442145969/dashboards/fe72f469-1cf6-40bd-a539-78488f9547b6"
    }
  )
  project = "wikibase-cloud"

  timeouts {}
}
