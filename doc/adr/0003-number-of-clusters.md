# 3) Use two clusters

Date: 2021-10-29

## Status

accepted

## Context

Production will be made up of 2 kubernetes clusters.
Each one will hold a single environment, staging, or production.
wikibase.dev and wikibase.cloud respectively.

A second Kubernetes cluster in the GKE environment would push us over the free tier credits for cluster management.
https://cloud.google.com/kubernetes-engine/pricing#cluster_management_fee_and_free_tier
Having second cluster, would increase cost by ~75USD per month, with no extra resources available.

## Pro con list of having 2 clusters

| Pro                   | Con                   |
| --------------------- | --------------------- |
| Simpler setup to maintain                 | 75USD Manangement fee |
| Ability to test GKE k8s updates | No ability to share unused resources between clusters |
| Some services could be shared (like cert-manager) | Need to setup some services like cert-manager twice |
| More separation between staging and production | |
| Able to use same namespaces between clusters | |


## Decision

We decide that the separation, and lower complexity is worth the cost and will therefore use two clusters.

## Consequences

There will be two clusters.
