# Production

Production will be made up of 2 kubernetes clusters.
Each one will hold a single environment, staging, or production.
wikibase.dev and wikibase.cloud respectively.

A second Kubernetes cluster in the GKE environment would push us over the free tier credits for cluster management.
https://cloud.google.com/kubernetes-engine/pricing#cluster_management_fee_and_free_tier
Having second cluster, would increase cost by ~75USD per month, with no extra resources availible.

We decide that the seperation, and lower complexity is worth the cost.

## Pro con list of having 2 clusters

| Pro                   | Con                   |
| --------------------- | --------------------- |
| Simpler setup to maintain                 | 75USD Manangement fee |
| Ability to test GKE k8s updates | No ability to share unused resources between clusters |
| Some services could be shared (like cert-manager) | Need to setup some services like cert-manager twice |
| More separation between staging and production | |
| Able to use same namespaces between clusters | |

## Terraform

Setup a Google cloud project, including GKE cluster out of the box using kind in the `tf/env/prod` workspace.

## helmfile

> Generate kubeconfig entries for the staging and production clusters by running the following commands:
>
> ```
> gcloud container clusters get-credentials wbaas-2 # staging
> gcloud container clusters get-credentials wbaas-3 # production 
> ```


Apply helmfiles from the `k8s/helmfile` directory with either `helmfile --environment <environment-name> diff/apply`.

The current environments are in flux, and to be detailed here soon.
