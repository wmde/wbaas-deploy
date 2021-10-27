# Production

Production is made up of a single kubernetes cluster that holds both a staging environment and production environment.
wikibase.dev and wikibase.cloud respectively.

A single Kubernetes cluster was chosen to save on resources and cost, and allow free resources to be shared between multiple environments.

A second Kubernetes cluster in the GKE environment would push us over the free tier credits for cluster management.
https://cloud.google.com/kubernetes-engine/pricing#cluster_management_fee_and_free_tier
Having 2 cluster, would increase cost by ~75USD per month, with no extra resources availible.

## Pro con list of having 2 clusters

| Pro                   | Con                   |
| --------------------- | --------------------- |
| Simpiler setup to maintain                       | 75USD Manangement fee |
| Ability to test GKE k8s updates | No ability to share unused resources between clusters |
| Some services could be shred (like cert-manager) | Need to setup some services like cert-mananger twice |
| More seperation between staging and production | |
| Able to use same namespaces between clusters | |

## Terraform

Setup a Google cloud project, including GKE cluster out of the box using kind in the `tf/env/prod` workspace.

## helmfile

Apply helmfiles from the `k8s/helmfile` directory with either `helmfile --environment <environment-name> diff/apply`.

The current environments are in flux, and to be detailed here soon.