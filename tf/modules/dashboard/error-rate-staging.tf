resource "google_monitoring_dashboard" "error-rate-staging" {
  dashboard_json = <<EOF
{
  "category": "CUSTOM",
  "displayName": "Error Rate (Staging)",
  "labels": {
    "staging": ""
  },
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "height": 4,
        "widget": {
          "title": "api error-rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"container_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"container_name\"=monitoring.regex.full_match(\"api-\\\\w+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 6,
        "yPos": 8
      },
      {
        "height": 4,
        "widget": {
          "title": "mediawiki pod error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"pod_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"mediawiki-\\\\w+-\\\\w+-\\\\w+-\\\\w+-.+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 0,
        "yPos": 4
      },
      {
        "height": 4,
        "widget": {
          "title": "mediawiki error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "metadata.user_labels.\"app.kubernetes.io/component\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"mediawiki-\\\\w+-\\\\w+-\\\\w+-\\\\w+-.+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 6,
        "yPos": 4
      },
      {
        "height": 4,
        "widget": {
          "title": "queryservice error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_AREA",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"container_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"queryservice-.+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 0,
        "yPos": 8
      },
      {
        "height": 4,
        "widget": {
          "title": "nginx-ingress-controller error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"pod_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"nginx-ingress-controller-.+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 6,
        "yPos": 12
      },
      {
        "height": 4,
        "widget": {
          "title": "platform-nginx error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"pod_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"platform-nginx-.+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 0,
        "yPos": 12
      },
      {
        "height": 4,
        "widget": {
          "title": "mariadb error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"pod_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"sql-mariadb.+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 0,
        "yPos": 16
      },
      {
        "height": 4,
        "widget": {
          "title": "tool pod error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"pod_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"tool-\\\\w+-.+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 6,
        "yPos": 16
      },
      {
        "height": 4,
        "widget": {
          "logsPanel": {
            "filter": "resource.labels.cluster_name=\"wbaas-2\"\nseverity=ERROR\n-\"cert-manager\"",
            "resourceNames": [
              "projects/658442145969"
            ]
          },
          "title": "Error logs (filtered)"
        },
        "width": 12,
        "xPos": 0,
        "yPos": 0
      },
      {
        "height": 4,
        "widget": {
          "title": "ui pod error rate",
          "xyChart": {
            "chartOptions": {
              "mode": "COLOR"
            },
            "dataSets": [
              {
                "minAlignmentPeriod": "60s",
                "plotType": "STACKED_BAR",
                "targetAxis": "Y1",
                "timeSeriesQuery": {
                  "apiSource": "DEFAULT_CLOUD",
                  "timeSeriesFilter": {
                    "aggregation": {
                      "alignmentPeriod": "60s",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"pod_name\""
                      ],
                      "perSeriesAligner": "ALIGN_RATE"
                    },
                    "filter": "metric.type=\"logging.googleapis.com/log_entry_count\" resource.type=\"k8s_container\" metric.label.\"severity\"=\"ERROR\" resource.label.\"pod_name\"=monitoring.regex.full_match(\"ui-\\\\w+-\\\\w+\") resource.label.\"cluster_name\"=\"wbaas-2\""
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
        "width": 6,
        "xPos": 0,
        "yPos": 20
      }
    ]
  }
}
EOF
}