# wbaas-deploy

This repository covers a production and development setup, held together with terraform, helmfile and the odd bash script.

## Development

### minikube cluster

Install minikube https://minikube.sigs.k8s.io/docs/start/

And start a local k8s cluster for the wbaas project.

```sh
minikube --profile minikube-wbaas start 
```

Once created, your kubectl context will automaticly switch to `minikube-wbaas`.

If you want to throw the whole cluster away you can delete it:

```sh
minikube --profile minikube-wbaas delete
```

#### Dashboard

minikube comes with a nice dahsboard that you can turn on with a simple command.

```sh
minikube --profile minikube-wbaas dashboard
```

### helmfile

Apply the helmfiles that are setup to work with the local environment with `helmfile --environment local diff/apply` in the `k8s/helmfile` directory.

**Note: This is a work in progress**

## Production

### Terraform

Setup a Google cloud project, including GKE cluster out of the box using kind in the `tf/dev/prod` workspace.

### helmfile

Apply helmfiles from the `k8s/helmfile` directory with either `helmfile diff/apply` or `helmfile --environment production diff/apply` in the `k8s/helmfile` directory.

Charts that are not contianed within the root `helmfile.yaml` will still need to be applied seperatly from within each directory.