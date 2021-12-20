# Local Development Environment

## Requirements

You need the following things installed on your machine:
* [docker](https://docs.docker.com/engine/install/ubuntu/)
* [minikube](https://minikube.sigs.k8s.io/docs/start/)
* [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
* [helm](https://helm.sh/docs/intro/install/)
  * diff plugin `helm plugin install https://github.com/databus23/helm-diff`
  * git plugin `helm plugin install https://github.com/aslafy-z/helm-git`
* [helmfile](https://github.com/roboll/helmfile#installation)
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/)
* (optional) [yamllint](https://github.com/adrienverge/yamllint#installation)

## Makefile
This repo has a [`Makefile`](../Makefile) in the root directory which allows us to use the `make` command to speed up common tasks.   
Usage: `make <command>`. Example: `make minikube-start`.  

This doc will reference the `make` commands where available. View the [`Makefile`](../Makefile) to see all the available commands and what they do.  

## minikube cluster

Install minikube (https://minikube.sigs.k8s.io/docs/start/), and start a local k8s cluster for the wbaas project.

**IMPORTANT: make sure you are NOT connected to the WMDE VPN when starting the minikube cluster**.

```sh
make minikube-start
```

Once created, your kubectl context will automatically switch to `minikube-wbaas`. You can verify this by running one of the following commands:

```sh
$ kubectl config get-contexts
CURRENT    NAME              CLUSTER           AUTHINFO          NAMESPACE
*          minikube-wbaas    minikube-wbaas    minikube-wbaas    default
```

```sh
$ kubectl config current-context
minikube-wbaas
```

You can stop the cluster with:
```sh
make minikube-stop
```

If you want to throw the whole cluster away, you can delete it with:
```sh
make minikube-delete
```

### minikube dashboard

minikube comes with a nice web dashboard that you can turn on with:

```sh
make minikube-dashboard
```

## terraform

Terraform is required to setup some needed dependencies. It interacts with a k8s cluster, that you need to have created beforehand (see the [minikube cluster](#minikube-cluster) section)!

To initialise terraform for the local environment, run the following in the `tf/env/local` dir:
```sh
terraform init
```

For convenience, you can store local secrets for the cluster in `.tfvars` files which will be ignored by git. 

Create a `terraform.tfvars` file in `tf/env/local` and add the recaptcha secrets to it. You can use [test keys][test-keys] for the v2 secrets. For v3 you will have to create your own secrets via the [v3 admin console](https://www.google.com/recaptcha/admin).

[test-keys]: https://developers.google.com/recaptcha/docs/faq#id-like-to-run-automated-tests-with-recaptcha.-what-should-i-do

```
recaptcha_v3_dev_site_key = "insert actual secret here"
recaptcha_v3_dev_secret   = "insert actual secret here"
recaptcha_v2_dev_site_key = "insert actual secret here"
recaptcha_v2_dev_secret   = "insert actual secret here"
```

To review the changes between what is applied to the infrastructure and the current configuration run:

```sh
terraform plan
```

The first time the `terraform plan` command is run the whole configuration will be displayed as none of the configuration will have been applied to the infrastructure before.

Once you have reviewed the output of `terraform plan`, you can apply the changes by running:

```sh
terraform apply
```

## helmfile

You can see the changes that helmfile will make to your local k8s cluster by running the following command in the `k8s/helmfile` directory

```sh
helmfile --environment local diff --context 5 # shows the diff with 5 lines of context around changes
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

## Mailhog / Local emails

For the local setup, [Mailhog](https://github.com/mailhog/MailHog) is used to capture outbound emails.

You can view those emails by going to http://mailhog.wbaas.localhost/

## [Optional] setup bash completion
Here is how to get tab completion working for common commands

Note: this was only tested on Ubuntu 20.04

```sh
# minikube
sudo sh -c 'minikube completion bash > /usr/share/bash-completion/completions/minikube'

# terraform
terraform -install-autocomplete

# kubectl
sudo sh -c 'kubectl completion bash > /usr/share/bash-completion/completions/kubectl'

# helm
sudo sh -c 'helm completion bash > /usr/share/bash-completion/completions/helm'

# helmfile
sudo wget https://raw.githubusercontent.com/roboll/helmfile/master/autocomplete/helmfile_bash_autocomplete -O /usr/share/bash-completion/completions/helmfile

# skaffold
sudo sh -c 'skaffold completion bash > /usr/share/bash-completion/completions/skaffold'
```

## Tests

Run `make test`. This only includes YAML linting for now.

## FAQ / Troubleshooting

**Why aren't my changes taking effect after a `terraform apply`?**  
Try restarting the pod(s) that are affected by the changed terraform configuration by deleting
them and waiting for k8s recreate them (`kubectl delete pod <pod_name>`).
