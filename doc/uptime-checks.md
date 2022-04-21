[< Back to index](README.md)

# Uptime checks

Uptime checks are defined in terraform and runs against both the staging and production cluster.

These are using the [google_monitoring_uptime_check_config](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_uptime_check_config) resource and requires a wiki to be manually setup with some content that the uptime checks are looking for.

## Setup example

For [staging](../tf/env/staging/uptime.tf), a developer has created a wiki like https://coffeebase.wikibase.dev on their own account and created a single item (Q1) with the english label `Arabica`. The uptime checks uses `GET` requests for validating that this and other expected responses is accessible through different endpoints and services.

The full list of checks are defined in the [variable.tf file of the uptime module](../tf/modules/uptime/main.tf).

## Uptime check overview

To view the last state of all the uptime checks for every region, visit the [Uptime checks](https://console.cloud.google.com/monitoring/uptime?project=wikibase-cloud) section in the cloud console.
## Viewing the metrics

These checks will be available as four different metrics under the  `monitoring.googleapis.com/uptime_check/` category.

* check_passed
* content_mismatch
* [request_latency](https://console.cloud.google.com/monitoring/metrics-explorer?project=wikibase-cloud&pageState=%7B%22xyChart%22:%7B%22dataSets%22:%5B%7B%22timeSeriesFilter%22:%7B%22filter%22:%22metric.type%3D%5C%22monitoring.googleapis.com%2Fuptime_check%2Frequest_latency%5C%22%20resource.type%3D%5C%22uptime_url%5C%22%22,%22minAlignmentPeriod%22:%2260s%22,%22aggregations%22:%5B%7B%22perSeriesAligner%22:%22ALIGN_MEAN%22,%22crossSeriesReducer%22:%22REDUCE_NONE%22,%22alignmentPeriod%22:%2260s%22,%22groupByFields%22:%5B%5D%7D,%7B%22crossSeriesReducer%22:%22REDUCE_NONE%22,%22alignmentPeriod%22:%2260s%22,%22groupByFields%22:%5B%5D%7D%5D%7D,%22targetAxis%22:%22Y1%22,%22plotType%22:%22LINE%22%7D%5D,%22options%22:%7B%22mode%22:%22COLOR%22%7D,%22constantLines%22:%5B%5D,%22timeshiftDuration%22:%220s%22,%22y1Axis%22:%7B%22label%22:%22y1Axis%22,%22scale%22:%22LINEAR%22%7D%7D,%22isAutoRefresh%22:true,%22timeSelection%22:%7B%22timeRange%22:%221h%22%7D%7D)
* time_until_ssl_cert_expires