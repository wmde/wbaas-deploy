# 7) Application level monitoring using Prometheus {#adr_0007}

Date: 2023-02-27

## Status

accepted

## Context

Wikibase.cloud is a complex distributed application.
To better understand its behavior, developers need insights beyond bare resource usage (i.e. CPU, RAM, disk).

## Decision

We settled on leveraging the [Prometheus][prometheus] ecosystem.
Prometheus is adopted widely, has an active community and is supported by the CNCF, making it an obvious choice for us.
In addition to that, Google Cloud Platform also offers a managed Prometheus service (storing data for us, and also feeding it into the GCP Monitoring Dashboard), meaning we don't need to manage storage requirements for that service.

[prometheus]: https://prometheus.io/

### Self-deployed collection 

While using the managed Prometheus service could mean we wouldn't have to deploy a Prometheus instance into our cluster at all, it would also mean we cannot easily replicate the monitoring setup locally.
Instead, we decided to use an approach called ["self-deployed collection"][self-deployed-docs].
This approach shims out the Prometheus instance with a GCP provided image that exposes the same interface as Prometheus proper, but will instead forward data to the managed service.
In local development, the shim layer is not used and data will be consumed by a default Prometheus instance.

[self-deployed-docs]: https://cloud.google.com/stackdriver/docs/managed-prometheus/setup-unmanaged

## Consequences

We chose to deploy the [`kube-prometheus-stack`][kube-prometheus-stack] Helm chart.
The chart contains many different components of a monitoring stack (collection, alerting, graphing), allowing us to gradually roll out features as needed.

The chart is using the ["Prometheus Operator"][prom-operator] which is a [Kubernetes operator][operator-pattern] responsible for managing the Prometheus instance, as well as picking up what resources to monitor, and defining which rules to apply.

[prom-operator]: https://github.com/prometheus-operator/prometheus-operator
[operator-pattern]: https://kubernetes.io/docs/concepts/extend-kubernetes/operator/

### `ServiceMonitor`s and `PodMonitor`s

To know where to collect metrics, the Prometheus operator looks for `ServiceMonitor` and `PodMonitor` Kubernetes objects (these are defined as CRDs) and __will collect metrics from all of those that are labeled with the `release: kube-prometheus-stack` label__.
A `ServiceMonitor` or `PodMonitor` does not deploy any pods, but merely serves as a container for scraping configuration.
Prometheus itself will still scrape the services' or pods' Prometheus compatible `metrics` endpoints. 

[kube-prometheus-stack]: https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
