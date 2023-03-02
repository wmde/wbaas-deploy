# 8) Deploying a service mesh to the Kubernetes Cluster {#adr_0008}

Date: 2023-03-02

## Status

proposed

## Context

Wikibase.cloud is a non-trivial distributed application.
Maintaining application quality requires good understanding of service level requirements and challenges.
If we want to be able to deliver upon this, developers need better insights into how services are used in production environments, how they perform individually, and how the interact with each other.
Right now, there is no well defined way into acquiring such data points.

### Introducing a service mesh

The prevailing industry standard for solving this problem is using a ["service mesh"][what-is-service-mesh].
It acts as a transparent layer on top of either the existing services or the existing hardware, allowing the mesh to control the flow of traffic, or collect metrics about it.

[what-is-service-mesh]: https://www.redhat.com/en/topics/microservices/what-is-a-service-mesh

### Requirements

When looking at options for deploying a service mesh to our cluster, the following requirements would need to be met:

- It's possible to install with our current tooling only (i.e. Helm + Terraform)
- It should be possible to uninstall it easily
- We don’t need to change our infrastructure setup for it
- It gives us Prometheus compatible metrics out of the box

### Options

Looking at the current landscape as of early 2023, 3 options have been evaluated.

#### 1. Istio

Evaluating [Istio][istio-web], we found:

- Established and mature project
- Large user base
- CNCF Incubating project
- Complex configuration options
- Leverages Envoy Sidecar proxies injected at runtime

[istio-web]: https://istio.io/latest/

##### Pros

- Can be installed using only Helm
- Can be uninstalled again without leaving a trace
- Envoy gives us Prometheus compatible metrics out of the box
- Easy to adopt additional features (e.g. mTLS) gradually

##### Cons

- Envoy is relatively resource hungry, adding resource overhead
- Configuration is complex

#### 2. Linkerd

Evaluating [Linkerd][linkerd-web], we found:

- Linkerd2, a complete rewrite is relatively young, but has a lot of hype around it
- Already large user base
- CNCF Gradudated project
- Not too many knobs to configure
- Injects a custom proxy as a sidecar

[linkerd-web]: https://linkerd.io/

##### Pros

- Can be installed using Helm and Terraform
- Can be uninstalled again without leaving a trace
- The custom proxy gives us Prometheus compatible metrics out of the box
- Has a low resource footprint

##### Cons

- Using mTLS is non-optional, making it hard to adopt the solution gradually
- The company behind Linkerd seems to write a lot of blogspam, so I am not entirely sure how much of the hype behind it is real

#### 3. Cilium

Evaluating [Cilium][cilium-web], we found:

- Young
- CNCF Incubating project
- Aims to be more than a service mesh
- Works at Kernel level

[cilium-web]: https://cilium.io/

##### Pros

- Can do a lot of things you cannot achieve using a Sidecar proxy (e.g. system level security features)

##### Cons

- The advised way of installing requires migrating to a new GKE cluster
- A lot of unknown concepts involved

## Decision

__I'd propose to choose Istio__ for the following reasons:

- it's the most boring option, giving us what we need when we want it, without having to opt in to some side effect (mTLS) at the same time
- it's easy to roll it out gradually
- it's easy to uninstall it again
- it seems to be well integrated with Prometheus and the Prometheus operator
- considering we don't run thousands of services in our clusters, the additional resource requirements are mostly negligible

## Consequences

Giving Istio a try would happen in the following stages:

### 1. Install the control plane as a no-op

In a first step, we'd install the "istio control plane" without labeling any services.
This means, that after deployment, the service should work just like before and the control plane is waiting for services to get labeled.

### 2. Label ElasticSearch pods to be managed by Istio

Once the control plane is running, we can start using the service mesh by labeling ElasticSearch pods in a way that they will be managed by istiod.
This allows us to:

- see how Istio behaves, while still keeping the risks of something unexpected happening low (worst case scenario is search going down)
- gain insights on the quality of service provided to users by ElasticSearch

### 3. Roll out for all services (or uninstall)

Once we know Istio is working as intended, and have decided we want to further leverage the service mesh, we can roll out Istio by either:

- Labeling further services one by one
- Labeling the `default` namespace as injectable

Alternatively, we can choose to uninstall the service mesh again.  
