# Local Development Environment

## Requirements

You need the following things installed on your machine:
* [docker](https://docs.docker.com/engine/install/ubuntu/)
* [minikube](https://minikube.sigs.k8s.io/docs/start/)
* [opentofu](https://opentofu.org/docs/intro/install/)
* [helm](https://helm.sh/docs/intro/install/)
  * diff plugin `helm plugin install https://github.com/databus23/helm-diff`
  * git plugin `helm plugin install https://github.com/aslafy-z/helm-git`
* [helmfile](https://github.com/helmfile/helmfile#installation)
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

## opentofu

Opentofu is required to setup some needed dependencies. It interacts with a k8s cluster, that you need to have created beforehand (see the [minikube cluster](#minikube-cluster) section)!

To initialise opentofu for the local environment, run the following in the `tf/env/local` dir:
```sh
tofu init
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
tofu plan
```

The first time the `tofu plan` command is run the whole configuration will be displayed as none of the configuration will have been applied to the infrastructure before.

Once you have reviewed the output of `tofu plan`, you can apply the changes by running:

```sh
tofu apply
```

## helmfile

Helmfile is a declarative spec for deploying helm charts to k8s clusters.

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
> - `make diff-local` - which will do a `tofu plan` followed by a `helmfile diff`
> - `make apply-local` - which will do a  `tofu apply` followed by a `helmfile apply`
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

You should now be able to access the ingress via http://www.wbaas.dev/ (*.wbaas.dev should point to 127.0.0.1, otherwise you'll need to edit your hosts file).

> [!NOTE]
> Previously `*.wbaas.localhost` was used for this purpose

More detailed information on the load balancer can be found in [minikube-load-balancer.md](minikube-load-balancer.md).

## Install local CA certificate
Since we [introduced](https://phabricator.wikimedia.org/T378691) using HTTPS for local ingresses, you will get a scary warning when accessing local web interfaces. This can be mitigated by trusting the local CA certificate that is getting used for self-signing. The easiest way to do this is to save the local CA certificate in a file by accessing the secret it lives in (`wikibase-local-tls`) and importing it in your browser settings. There is also the possibility to import it into the trust store of your operating system, for example via the tool [mkcert](https://github.com/FiloSottile/mkcert), but you should be aware of the possible consequences this could have for the security of your machine.

> [!TIP]
> Running `make local-ca` will save the certificate to the file `wikibase-local-tls.crt`. It is highly recommended to delete the file again after importing it.

> [!NOTE]
> If you recreate your local cluster, you have to re-import the CA certificate, as a new one will get generated and used instead.

## Mailhog / Local emails

For the local setup, [Mailhog](https://github.com/mailhog/MailHog) is used to capture outbound emails.

You can view those emails by going to http://mailhog.wbaas.dev/

## Mediawiki debugging 
### logging

To increase verbosity of logging in the mediawiki pods you can change the following value in the mediawiki deployment to enable debug logging to appear in all of the pods.

```yml
mw:
  settings:
    logToStdErr: true
```

Apply the changes to the local cluster 
```sh
make apply-local
```

### Xdebug

Xdebug can be enabled in your minikube cluster if you use mediawiki image with `skaffold`, it is by default enabled with skaffold but running the cluster with `make apply-local` does not include xdebug by default.
- You can use Xdebug on your phpstorm IDE by following this steps:
  * Install xdebug helper extension for your browser.
  * Toggling the "Listening PHP Debug Connection" button.
  * Put a breakpoint in the code by clicking on the right of the line number in your IDE 
  * Load the application on your browser and see the debugging output on your IDE, related to your break point.
- You can use Xdebug on your VSCode IDE by following these steps:
  * Follow this tutorial in the section "Debug PHP using Xdebug and VS Code" https://php.tutorials24x7.com/blog/how-to-debug-php-using-xdebug-and-visual-studio-code-on-ubuntu

## Create an account on wbaas.dev
To use the local wbaas instance you have just setup, you will need to create an invitation code via the api which is needed when creating an account. Follow the [instructions](https://github.com/wbstack/api/blob/main/docs/invitation-codes.md) documented in the wbaas/api repo.

After creating the invitation code, you can visit http://wbaas.dev/create-account (or click the create account link in the login form) and create an account. All outbound email is captured by Mailhog ([see above](#mailhog--local-emails)) so you can use a made up email address (e.g. `test@example.com`). Verify your email address via the "Account Creation Notificaiton" email captured by Mailhog.

## [Optional] setup bash completion
Here is how to get tab completion working for common commands

Note: this was only tested on Ubuntu 20.04

```sh
# minikube
sudo sh -c 'minikube completion bash > /usr/share/bash-completion/completions/minikube'

# opentofu
tofu -install-autocomplete

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

## Accessing the SQL database for debugging
You can do this using `adminer` which is available at adminer.wbaas.dev.
You can get the root password by using `bin/get-maria-root-password`.
The username is `root`.
You can select the primary server at `sql-mariadb-primary.default.svc.cluster.local`.

`apidb` is the default name of the api database.

You can also port forward sql to your local machine and use something like datagrip.

## FAQ / Troubleshooting
### **Why aren't my changes taking effect after a `tofu apply`?**
Try restarting the pod(s) that are affected by the changed opentofu configuration by deleting them and waiting for k8s to recreate them (`kubectl delete pod <pod_name>`).

### **Why did `make diff-local` fail to download a chart?**
If you get an error similar to this:

```
Error: Failed to render chart: exit status 1: Error: failed to download "wbstack/mediawiki" at version "0.7.3"
Error: plugin "diff" exited with error
```

it is likely because `make diff-local` uses the `--skip-deps` option when executing `helmfile diff` which skips downloading chart dependencies. To force the fetching of dependencies run `make helmfile-deps` before `make diff-local`. 

### **Why can't I access [wbaas.dev](http://www.wbaas.dev)?**
Here are a few things to try:
  - make sure minikube is running `make minikube-start`
  - make sure the minikube tunnel is running `make minikube-tunnel`
  - make sure you are using https:// and not http://
  - check the health of your pods `kubectl --profile minikube-wbaas get pods`

### **API isn't running // Some pods are missing**
While running an initial `helmfile apply` for setting up all the k8s resources, it can happen that it doesn't complete all deployments, but helm thinks it did. To make sure everything that should be deployed was actually deployed, you can run `make helmfile-sync`.

### **Unable to resolve the current Docker CLI context**
If you get a warning similar to the below while running a `minikube` command:

```
$ minikube version
W0602 10:50:58.273416 2657756 main.go:291] Unable to resolve the current Docker CLI context "default": context "default": context not found: open /home/ollie/.docker/contexts/meta/37a8eec1ce19687d132fe29051dca629d164e2c4958ba141d5f4133a33f0688f/meta.json: no such file or directory
minikube version: v1.34.0
commit: 210b148df93a80eb872ecbeb7e35281b3c582c61
```

Try setting the docker context (even if one is already set):
* `docker context ls` lists the available contexts
* `docker context use default` sets the "default" context
