# wbaas-deploy

This repository covers a production and development setup, held together with terraform, helmfile and the odd bash script.

- `bin` - Contains helpful scripts for interacting with deployments
- `charts` - Contains any custom [helm](https://helm.sh/) charts not taken from other repositories or [wbstack charts](https://github.com/wbstack/charts) / [deploy](https://github.com/wbstack/deploy)
- `gce` - Scripts for manual creation and maintenance of [Google Cloud](https://cloud.google.com/) resources (ideally will transition to terraform)
- `k8s` - Interaction with [Kubernetes](https://kubernetes.io/)
  - `k8s/helmfile` - Interaction with kubernetes via [helmfile](https://github.com/roboll/helmfile) deployments of [helm](https://helm.sh/) charts
- `tf` - [Terraform](https://www.terraform.io/) environments

## Development

You can already run a local k8s cluster and some, but not all services.

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

#### LoadBalancer

minikube does not provision LoadBalancer service IP addresses as part of normal operation.
It will only do this if you additionally run the `tunnel` command.
As a result if you provision a LoadBalancer services such as an ingress the `EXTERNAL-IP` will continue to say `<pending>` long after creation.

In order to skip out this LoadBalancer stuff you can get minikube to expose the ingress directly on a port.

```sh
minikube --profile minikube-wbaas service -n kube-system nginx-ingress-default-backend
```

Note: There is more to making things work lcoally than this and we either need to setup dynamic DNS, or we need to be editing our hosts file!

### helmfile

Apply the helmfiles that are setup to work with the local environment with `helmfile --environment local diff/apply` in the `k8s/helmfile` directory.

**Note: This is a work in progress**

Once everyting is running, you should be able to see the pods.

```sh
kubectl --context minikube-wbaas get pods -A
```

And connect to containers if needed, such as the redis master.

```sh
./bin/k8s-access -e local -r redis -l role=master
```

## Production

Production is made up of a staging environment and production environment.
wikibase.dev and wikibase.cloud respectively.

### Terraform

Setup a Google cloud project, including GKE cluster out of the box using kind in the `tf/dev/prod` workspace.

### helmfile

Apply helmfiles from the `k8s/helmfile` directory with either `helmfile diff/apply` or `helmfile --environment production diff/apply` in the `k8s/helmfile` directory.

Charts that are not contianed within the root `helmfile.yaml` will still need to be applied seperatly from within each directory.