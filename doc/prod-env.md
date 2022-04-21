# Production
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

## Snapshots

To setup disk snapshots, see [Disk snapshots](backups/disk-snapshots.md)
