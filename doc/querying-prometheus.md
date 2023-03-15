# Querying Prometheus using the Google Cloud Console

Metrics data from our GKE clusters is persisted in [GCP's Managed Prometheus][managed-prom] service.
For the time being, the main entry point for querying this data is GCP's "Metric Explorer", which lets you run queries against the Prometheus instance.

[managed-prom]: https://cloud.google.com/stackdriver/docs/managed-prometheus

<!-- MarkdownTOC -->

- [Introduction to basic concepts used in Prometheus](#introduction-to-basic-concepts-used-in-prometheus)
    - [Labeled timeseries data](#labeled-timeseries-data)
    - [Relevant metric types](#relevant-metric-types)
    - [Prometheus Query Language](#prometheus-query-language)
- [Getting relevant KPIs for Wikibase.cloud](#getting-relevant-kpis-for-wikibasecloud)
    - [ElasticSearch](#elasticsearch)
    - [Istio Service Mesh](#istio-service-mesh)
    - [Nginx Ingress Controller](#nginx-ingress-controller)

<!-- /MarkdownTOC -->

## Introduction to basic concepts used in Prometheus

[Prometheus][prom] is a database ecosystem designed specifically for storing and querying timeseries data emitted by monitoring systems.

[prom]: https://prometheus.io/

### Labeled timeseries data

Each datapoint in a time series is a timestamped tuple of a metric name and a numeric (float64) value.
In addition to that, labels (arbitrary key value pairs) can be applied to a datapoint.

For example, a HTTP server that has since start served 2.319 GET requests with a 200 status code, could emit data like this: 

```
# metric_name{label_name=label_value, ...} value
http_requests_total{method="GET", response_code="200"} 2319
```

### Relevant metric types

When putting multiple of these datapoints into relation, different metric types are used.

#### Counters

A counter accumulates the total occurrences of a specific event.
It can only ever grow unless the emitting system is restarted.
E.g. the number of requests served by a server could be represented using a counter:

```
http_requests_total{method="GET"} 192
http_requests_total{method="GET"} 198 # 6 GET requests have been served since the last datapoint
```

#### Gauges

A gauge is used to represent a numerical value that can both grow and decrease.
E.g. the total number of rows in a database growing over time could be represented using a gauge.
```
db_rows{table="users"} 44
db_rows{table="users"} 50 # 6 users have been added since the last datapoint
db_rows{table="users"} 48 # 2 users have been deleted since the last datapoint
```

#### Distributions

Distributions (also called Histograms) samples a metric and distributes the values in configurable buckets.
This is usually done by emitting three datapoints at once.
When observing a behavior called `beeps`, `beeps_sum` (the total sum of all observed values), `beeps_count` (the count of events that have been observed) and `beeps_bucket` (cumulative counters for certain buckets) are emitted.
`_bucket` values signal their upper bounds using a `le` label:

```
response_time_bucket{le="200"} 1234 # 1234 requests have been served in less than 200ms
```

Distributions are a good fit for describing sampled data like response times.

### Prometheus Query Language

Prometheus comes with a language for querying data called [PromQL][promql].
In its most simple form, its syntax resembles a datpoint without a value:

```
db_rows{table="boops"} # query for the number of boops in the database
```

Label selectors can be filtered:

```
http_requests_total{method!="GET"} # number of non-GET requests
```

Values can also be aggregated using ["functions"][promql-functions]:

```
sum(db_rows) # query for the number of all rows in all tables
```

Distributions can be queried for percentiles using `histogram` functions: 

```
# get the response time's 95th percentile
histogram_quantile(0.95, rate(response_time_bucket{}[1m])) by (le))
```

[promql]: https://prometheus.io/docs/prometheus/latest/querying/basics/
[promql-functions]: https://prometheus.io/docs/prometheus/latest/querying/basics/

## Getting relevant KPIs for Wikibase.cloud

Applying the above to our setup, the following relevant queries can be used for observing our services in the [Metrics Explorer][metrics-explorer].
Note that these are just examples to get you started and more services might have been made available since the time of writing this document.

[metrics-explorer]: https://console.cloud.google.com/monitoring/metrics-explorer?project=wikibase-cloud

### ElasticSearch

#### Thread Pools by Type

```
sum by (type) (
  elasticsearch_thread_pool_threads_count{cluster="wbaas-3"}
)
```

#### Time spent garbage collecting

```
sum by (gc) (
  increase(elasticsearch_jvm_gc_collection_seconds_count{cluster="wbaas-3"}[1m])
)
```

### Istio Service Mesh

#### ElasticSearch error rate in perecent

```
(
  sum(increase(istio_requests_total{cluster="wbaas-3", destination_canonical_service="elasticsearch-master", response_code=~"5.+"}[1m]))
  /
  sum(increase(istio_requests_total{cluster="wbaas-3", destination_canonical_service="elasticsearch-master"}[1m]))
)
  *
100
```

#### ElasticSearch average response time in seconds

```
(
  sum(increase(istio_request_duration_milliseconds_sum{cluster="wbaas-3", destination_canonical_service="elasticsearch-master"}[1m]))
  /
  sum(increase(istio_request_duration_milliseconds_count{cluster="wbaas-3", destination_canonical_service="elasticsearch-master"}[1m]))
)
  /
1000
```

#### ElasticSearch response times 95th percentile

```
histogram_quantile(
  0.95,
  sum(
    rate(istio_request_duration_milliseconds_bucket{cluster="wbaas-3", destination_canonical_service="elasticsearch-master"}[5m])
  ) by (le)
)
```

### Nginx Ingress Controller

#### Requests per second

```
sum(
  rate(nginx_ingress_controller_requests{cluster="wbaas-3"}[1m])
)
```

#### Error rate in percent

```
(
  sum(increase(nginx_ingress_controller_requests{cluster="wbaas-3", status=~"5.+"}[1m]))
  /
  sum(increase(nginx_ingress_controller_requests{cluster="wbaas-3"}[1m]))
)
  *
100
```
