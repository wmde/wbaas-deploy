# Production

Production is made up of a staging environment and production environment.
wikibase.dev and wikibase.cloud respectively.

## Terraform

Setup a Google cloud project, including GKE cluster out of the box using kind in the `tf/env/prod` workspace.

## helmfile

Apply helmfiles from the `k8s/helmfile` directory with either `helmfile diff/apply` or `helmfile --environment staging diff/apply` in the `k8s/helmfile` directory.

Charts that are not contained within the root `helmfile.yaml` will still need to be applied separately from within each directory.