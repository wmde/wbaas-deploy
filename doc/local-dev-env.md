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

Install minikube (https://minikube.sigs.k8s.io/docs/start/), and start a local kubernetes (k8s) cluster for the wbaas project.

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

Helmfile is a declaraive spec for deploying helm charts to k8s clusters.

You can see the changes that helmfile will make to your local k8s cluster by running the following command in the `k8s/helmfile` directory:

```sh
helmfile --environment local diff --context 5 # shows the diff with 5 lines of context around changes
```

To actually make the changes use:

```sh
helmfile --environment local apply
```

In order to speed things up you can add `--skip-deps` after the `diff` or `apply` commands if you are not expecting to pull in changes.

> **NOTE** \
> For convenience, you can (from the root of the repository) run:
> - `make diff-local` - which will do a `terraform plan` followed by a `helmfile diff`
> - `make apply-local` - which will do a  `terraform apply` followed by a `helmfile apply`
>
> Be aware that both these commands run `helmfile` with the `--skip-deps` option. If you need to fetch any changes, make sure to do a `make helmfile-deps` beforehand.

## Verify everything is running

Once everything is running, you should be able to see the pods:

```sh
kubectl --context minikube-wbaas get pods
```

You should expect to see the following containers with status `Running` (the container names will include extra character at the end):

- adminer
- api-app-backend
- api-app-web
- api-queue
- api-scheduler
- elasticsearch-master
- mailhog
- mediawiki-[version]-app-alpha
- mediawiki-[version]-app-api
- mediawiki-[version]-app-backend
- mediawiki-[version]-app-web
- platform-nginx
- queryservice
- queryservice-gateway
- queryservice-ui
- queryservice-updater
- redis-master
- redis-replicas
- sql-mariadb-primary
- sql-mariadb-secondary
- tool-cradle
- tool-quickstatements
- tool-widar
- ui

and the following containers with status `Completed`:

- api-pre-install-artisan-setup

You can connect to containers if needed, such as the redis master:

```sh
kubectl --context minikube-wbaas exec -it reddis-master-0 -- bash

# or with the convenience script

./bin/k8s-shell -e local -r redis -l role=master
```

### LoadBalancer

minikube does not provision LoadBalancer service IP addresses as part of normal operation. It will only do this if you additionally run the `minikube tunnel` command. As a result if you provision a LoadBalancer services, such as an ingress, the `EXTERNAL-IP` will continue to say `<pending>` long after creation.

```sh
make minikube-tunnel
```

You should now be able to access the ingress via http://www.wbaas.localhost. Most modern browsers will automatically resolve *.localhost to 127.0.0.1. If not, you'll need to edit your hosts file.

More detailed information on the load balancer can be found in [minikube-load-balancer.md](minikube-load-balancer.md).

## Mailhog / Local emails

For the local setup, [Mailhog](https://github.com/mailhog/MailHog) is used to capture outbound emails.

You can view those emails by going to http://mailhog.wbaas.localhost/

## Create an account on wbaas.localhost
To use the local wbaas instance you have just setup, you will need to create an invitation code via the api which is needed when creating an account. Follow the [instructions](https://github.com/wbstack/api/blob/main/docs/invitation-codes.md) documented in the wbaas/api repo.

After creating the invitation code, you can visit http://wbaas.localhost/create-account (or click the create account link in the login form) and create an account. All outbound email is captured by Mailhog ([see above](#mailhog--local-emails)) so you can use a made up email address (e.g. `test@example.com`). Verify your email address via the "Account Creation Notificaiton" email captured by Mailhog.

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

## Testing changes
[skaffold](https://skaffold.dev) is used to load changes made in other repositories (e.g. `api`, `mediawiki`, `quickstatements`, etc) into the pods running in minikube. See the [README](../skaffold/README.md) in the skaffold directory for details on how to use.

## Tests

Run `make test`. This only includes YAML linting for now.

## FAQ / Troubleshooting
### **Why aren't my changes taking effect after a `terraform apply`?**
Try restarting the pod(s) that are affected by the changed terraform configuration by deleting them and waiting for k8s to recreate them (`kubectl delete pod <pod_name>`).

### **Why did `make diff-local` fail to download a chart?**
If you get an error similar to this:

```
Error: Failed to render chart: exit status 1: Error: failed to download "wbstack/mediawiki" at version "0.7.3"
Error: plugin "diff" exited with error
```

it is likely because `make diff-local` uses the `--skip-deps` option when executing `helmfile diff` which skips downloading chart dependencies. To force the fetching of dependencies run `make helmfile-deps` before `make diff-local`. 

### **Why can't I access [wbaas.localhost](http://www.wbaas.localhost)?**
Here are a few things to try:
  - make sure minikube is running `make minikube-start`
  - make sure the minikube tunnel is running `make minikube-tunnel`
  - make sure you are using http:// and not https:// (there are no TLS certificates)
  - check the health of your pods `kubectl --profile minikube-wbaas get pods`
