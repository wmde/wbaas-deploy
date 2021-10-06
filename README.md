# wbaas-deploy

This repository covers a production and development setup, held together with terraform, helmfile and the odd bash script.

## Development

Setup a local kubernetes cluster out of the box using kind in the `tf/dev/local-cluster` workspace.

You could also choose to use another cluster provider such a minikube, but you will need to change references to kubectl contexts which are currently hardcoded to `kind-wbaas-local`.
In the fututure we will aim to have individual dev overrides for these.

Apply the helmfiles that are setup to work with the lcoal environment with `helmfile --environment local diff/apply`.
Note: This is a work in progress

## Production

Setup a Google cloud project, including GKE cluster out of the box using kind in the `tf/dev/prod` workspace.

Apply helmfiles from the `k8s/helmfile` directory with either `helmfile diff/apply` or `helmfile --environment production diff/apply`