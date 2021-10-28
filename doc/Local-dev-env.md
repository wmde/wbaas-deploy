# Local Development Environment

## minikube cluster

Install minikube https://minikube.sigs.k8s.io/docs/start/

And start a local k8s cluster for the wbaas project.

Note: 1.21.4 is suggested as this is the currently used production environments.

```sh
minikube --profile minikube-wbaas start --kubernetes-version=1.21.4
```

Once created, your kubectl context will automatically switch to `minikube-wbaas`.

If you want to throw the whole cluster away you can delete it:

```sh
minikube --profile minikube-wbaas delete
```

### Dashboard

minikube comes with a nice dashboard that you can turn on with a simple command.

```sh
minikube --profile minikube-wbaas dashboard
```

## terraform

Terraform is required to setup some needed dependencies.
You should be able to apply the needed state with `terraform apply` in `tf/env/local`.

Terraform interacts with a k8s cluster, that you need to create beforehand!

For convenience, you can add local secrets to your cluster via a `terraform.tfvars` file in `tf/env/local` (it will get ignored by git). Example for recaptcha keys:
```
recaptcha_v3_dev_site_key = "insert actual secret here"
recaptcha_v3_dev_secret   = "insert actual secret here"
recaptcha_v2_dev_site_key = "insert actual secret here"
recaptcha_v2_dev_secret   = "insert actual secret here"
```

## helmfile
> These helm plugins need to be installed:
> * [diff](https://github.com/databus23/helm-diff) - helmfile needs this to diff resources
> * [git](https://github.com/aslafy-z/helm-git) - We need this to fetch charts from git
>
> ```sh
> helm plugin install https://github.com/databus23/helm-diff
> helm plugin install https://github.com/aslafy-z/helm-git
> ```
>
You can see the changes that helmfile will make to your local k8s cluster by running the following command in the `k8s/helmfile` directory

```sh
helmfile --environment local diff
```

To actually make the changes use:

```sh
helmfile --environment local apply
```

In order to speed things up you can add `--skip-deps` after the `diff` or `apply` commands if you are not expecting to pull in changes.

**Note: This is a work in progress**

Once everything is running, you should be able to see the pods.

```sh
kubectl --context minikube-wbaas get pods -A
```

And connect to containers if needed, such as the redis master.

```sh
./bin/k8s-shell -e local -r redis -l role=master
```

### LoadBalancer

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
But this will expose things on a different port and you may run into issues.

```sh
minikube --profile minikube-wbaas service -n kube-system nginx-ingress-default-backend
```

Note: There is more to making things work locally than this and we either need to setup dynamic DNS, or we need to be editing our hosts file!