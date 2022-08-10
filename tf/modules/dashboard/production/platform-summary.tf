resource "google_monitoring_dashboard" "platform-summary-prod" {
  dashboard_json = <<EOF
{
  "category": "CUSTOM",
  "displayName": "Platform Summary (Production)",
  "labels": {
    "production": ""
  },
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 4,
        "widget": {
          "title": "wiki stats",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "86400s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "86400s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-deleted\" resource.type=\"k8s_container\""
                  }
                }
              },
              {
                "minAlignmentPeriod": "86400s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "86400s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-empty\" resource.type=\"k8s_container\""
                  }
                }
              },
              {
                "minAlignmentPeriod": "86400s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "86400s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-active\" resource.type=\"k8s_container\""
                  }
                }
              },
              {
                "minAlignmentPeriod": "86400s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "86400s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-inactive\" resource.type=\"k8s_container\""
                  }
                }
              },
              {
                "minAlignmentPeriod": "86400s",
                "plotType": "LINE",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "86400s",
                      "crossSeriesReducer": "REDUCE_MEAN",
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-total\" resource.type=\"k8s_container\""
                  }
                }
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            }
          }
        },
        "width": 10,
        "xPos": 0,
        "yPos": 2
      },
      {
        "height": 2,
        "widget": {
          "scorecard": {
            "blankView": {},
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "86400s",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "perSeriesAligner": "ALIGN_DELTA"
                },
                "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-total\" resource.type=\"k8s_container\""
              }
            }
          },
          "title": "total wikis"
        },
        "width": 2,
        "xPos": 0,
        "yPos": 0
      },
      {
        "height": 2,
        "widget": {
          "scorecard": {
            "blankView": {},
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "86400s",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "perSeriesAligner": "ALIGN_DELTA"
                },
                "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-active\" resource.type=\"k8s_container\""
              }
            }
          },
          "title": "active wikis"
        },
        "width": 2,
        "xPos": 2,
        "yPos": 0
      },
      {
        "height": 2,
        "widget": {
          "scorecard": {
            "blankView": {},
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "86400s",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "perSeriesAligner": "ALIGN_DELTA"
                },
                "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-deleted\" resource.type=\"k8s_container\""
              }
            }
          },
          "title": "deleted wikis"
        },
        "width": 2,
        "xPos": 6,
        "yPos": 0
      },
      {
        "height": 2,
        "widget": {
          "scorecard": {
            "blankView": {},
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "86400s",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "perSeriesAligner": "ALIGN_DELTA"
                },
                "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-inactive\" resource.type=\"k8s_container\""
              }
            }
          },
          "title": "inactive wikis"
        },
        "width": 2,
        "xPos": 8,
        "yPos": 0
      },
      {
        "height": 2,
        "widget": {
          "scorecard": {
            "blankView": {},
            "timeSeriesQuery": {
              "apiSource": "DEFAULT_CLOUD",
              "timeSeriesFilter": {
                "aggregation": {
                  "alignmentPeriod": "86400s",
                  "crossSeriesReducer": "REDUCE_MEAN",
                  "perSeriesAligner": "ALIGN_DELTA"
                },
                "filter": "metric.type=\"logging.googleapis.com/user/wbaas-3-platform-summary-empty\" resource.type=\"k8s_container\""
              }
            }
          },
          "title": "empty wikis"
        },
        "width": 2,
        "xPos": 4,
        "yPos": 0
      }
    ]
  }
}
EOF
}