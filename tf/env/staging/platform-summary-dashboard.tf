resource "google_monitoring_dashboard" "platform-summary" {
  dashboard_json = jsonencode(
    {
      displayName  = "Platform Summary (Staging)"
      labels       = {
        staging = ""
      }
      mosaicLayout = {
        columns = 12
        tiles   = [
          {
            height = 4
            widget = {
              title   = "wikis"
              xyChart = {
                chartOptions      = {
                  mode = "COLOR"
                }
                dataSets          = [
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          groupByFields      = [
                            "metric.label.\"cluster\"",
                          ]
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-deleted\" resource.type=\"k8s_container\""
                      }
                    }
                  },
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-empty\" resource.type=\"k8s_container\""
                      }
                    }
                  },
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-active\" resource.type=\"k8s_container\""
                      }
                    }
                  },
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-inactive\" resource.type=\"k8s_container\""
                      }
                    }
                  },
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total\" resource.type=\"k8s_container\""
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
            width  = 3
            yPos   = 4
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "total wikis"
            }
            width  = 2
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-active\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "active wikis"
            }
            width  = 2
            xPos   = 2
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-deleted\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "deleted wikis"
            }
            width  = 2
            xPos   = 6
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-inactive\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "inactive wikis"
            }
            width  = 2
            xPos   = 8
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-empty\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "empty wikis"
            }
            width  = 2
            xPos   = 4
          },
          {
            height = 8
            widget = {
              text  = {
                content = <<-EOT
                                    ##### Active wikis
                                    Edits made in the last 90 days

                                    ##### Inactive wikis
                                    \>90 days of no activity

                                    ##### Deleted wikis
                                    Soft-deleted wikis to be deleted

                                    ##### Active editors
                                    performed an action in the last 30 days
                                EOT
                format  = "MARKDOWN"
              }
              title = "Legend"
            }
            width  = 2
            xPos   = 10
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_pages\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "total pages"
            }
            width  = 2
            yPos   = 2
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_active_users\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "total active editors"
            }
            width  = 2
            xPos   = 6
            yPos   = 2
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_users\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "total editors"
            }
            width  = 2
            xPos   = 8
            yPos   = 2
          },
          {
            height = 2
            widget = {
              scorecard = {
                timeSeriesQuery = {
                  timeSeriesFilter = {
                    aggregation = {
                      alignmentPeriod    = "86400s"
                      crossSeriesReducer = "REDUCE_MEAN"
                      perSeriesAligner   = "ALIGN_DELTA"
                    }
                    filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_edits\" resource.type=\"k8s_container\""
                  }
                }
              }
              title     = "total edits"
            }
            width  = 2
            xPos   = 2
            yPos   = 2
          },
          {
            height = 4
            widget = {
              title   = "editors"
              xyChart = {
                chartOptions      = {
                  mode = "COLOR"
                }
                dataSets          = [
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_active_users\""
                      }
                    }
                  },
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_users\""
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
            width  = 3
            xPos   = 3
            yPos   = 4
          },
          {
            height = 4
            widget = {
              title   = "edits & pages"
              xyChart = {
                chartOptions      = {
                  mode = "COLOR"
                }
                dataSets          = [
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_edits\""
                      }
                    }
                  },
                  {
                    minAlignmentPeriod = "86400s"
                    plotType           = "LINE"
                    targetAxis         = "Y1"
                    timeSeriesQuery    = {
                      timeSeriesFilter = {
                        aggregation = {
                          alignmentPeriod    = "86400s"
                          crossSeriesReducer = "REDUCE_MEAN"
                          perSeriesAligner   = "ALIGN_DELTA"
                        }
                        filter      = "metric.type=\"logging.googleapis.com/user/wbaas-2-platform-summary-total_non_deleted_pages\""
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
            width  = 4
            xPos   = 6
            yPos   = 4
          },
        ]
      }
      name         = "projects/658442145969/dashboards/0936efa3-16b4-4a05-824a-08baf0268787"
    }
  )
  project        = "wikibase-cloud"

  timeouts {}
}
