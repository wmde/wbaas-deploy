# wbaas-deploy

This repository covers a production and development setup, held together with terraform, helmfile and the odd bash script.

- `bin` - Contains helpful scripts for interacting with deployments
- `charts` - Contains any custom [helm](https://helm.sh/) charts not taken from other repositories or [wbstack charts](https://github.com/wbstack/charts) / [deploy](https://github.com/wbstack/deploy)
- `gce` - Scripts for manual creation and maintenance of [Google Cloud](https://cloud.google.com/) resources (ideally will transition to terraform)
- `k8s` - Interaction with [Kubernetes](https://kubernetes.io/)
  - `k8s/helmfile` - Interaction with kubernetes via [helmfile](https://github.com/roboll/helmfile) deployments of [helm](https://helm.sh/) charts
    - `k8s/helmfile/env` - Per environment configuration (local vs prod)
- `skaffold` - Local development on top of locally deployed kubernetes using [skaffold](https://skaffold.dev/)
- `tf` - [Terraform](https://www.terraform.io/) environments
  - `tf/env` - Per environment configuration (local vs prod)

## Development

Terraform is required to setup some needed dependencies.
You should be able to apply the needed state with `terraform apply` in `tf/dev/local`.

Terraform interacts with a k8s cluster, that you ideally already need to have created!

### minikube cluster

Install minikube https://minikube.sigs.k8s.io/docs/start/

And start a local k8s cluster for the wbaas project.

Note: 1.21.4 is suggested as this is the currently used prouduction environment.

```sh
minikube --profile minikube-wbaas start --kubernetes-version=1.21.4
```

Once created, your kubectl context will automatically switch to `minikube-wbaas`.

If you want to throw the whole cluster away you can delete it:

```sh
minikube --profile minikube-wbaas delete
```

#### Dashboard

minikube comes with a nice dashboard that you can turn on with a simple command.

```sh
minikube --profile minikube-wbaas dashboard
```

#### LoadBalancer

minikube does not provision LoadBalancer service IP addresses as part of normal operation.
It will only do this if you additionally run the `tunnel` command.
As a result if you provision a LoadBalancer services such as an ingress the `EXTERNAL-IP` will continue to say `<pending>` long after creation.


```sh
minikube --profile minikube-wbaas tunnel
```

Running the tunnel on linux might require you to forward the traffic to the cluster IP of the nginx-ingress-controller. This can be done by running the following command. 

```sh
EXTERNAL_IP=$(minikube --profile minikube-wbaas kubectl -- -n kube-system get service nginx-ingress-controller -o template='{{.spec.clusterIP}}')
sudo socat tcp-listen:80,reuseaddr,fork tcp:"$EXTERNAL_IP":80
```

You should then be able to access the ingress (currently on port 80), and localhost services such as http://www.wbaas.localhost/.
Most modern browsers will automatically resolve *.localhost to 127.0.0.1.
If not, you'll need to edit your hosts file.

In order to skip out this LoadBalancer stuff you can get minikube to expose the ingress directly on a port.
But this will expose thing on a different port and you may run into issues.

```sh
minikube --profile minikube-wbaas service -n kube-system nginx-ingress-default-backend
```

Note: There is more to making things work locally than this and we either need to setup dynamic DNS, or we need to be editing our hosts file!

### helmfile

Apply the helmfiles that are setup to work with the local environment with `helmfile --environment local diff/apply` in the `k8s/helmfile` directory.

**Note: This is a work in progress**

Once everyting is running, you should be able to see the pods.

```sh
kubectl --context minikube-wbaas get pods -A
```

And connect to containers if needed, such as the redis master.

```sh
./bin/k8s-shell -e local -r redis -l role=master
```

## Production

Production is made up of a staging environment and production environment.
wikibase.dev and wikibase.cloud respectively.

### Terraform

Setup a Google cloud project, including GKE cluster out of the box using kind in the `tf/dev/prod` workspace.

### helmfile

Apply helmfiles from the `k8s/helmfile` directory with either `helmfile diff/apply` or `helmfile --environment production diff/apply` in the `k8s/helmfile` directory.

Charts that are not contianed within the root `helmfile.yaml` will still need to be applied seperatly from within each directory.