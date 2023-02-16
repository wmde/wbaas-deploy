# Tools

This is a collection of some useful tools to interface with our k8s clusters. It's not mandatory to use them, but they can be helpful.

## kubie
- https://blog.sbstp.ca/introducing-kubie/
- https://github.com/sbstp/kubie

> kubie is an alternative to kubectx, kubens and the k on prompt modification script. It offers context switching, namespace switching and prompt modification in a way that makes each shell independent from others.

### Basic usage
Run `kubie ctx` to get a selection of available contexts to choose from and select one with enter. A subshell is spawned with the chosen context, limited to that subshell.

Since switching the kube context can happen quite frequently it can be useful to bind it to a keystroke, for example via your `~/.inputrc` with an entry like `Control-k: "kubie ctx\n"`.

## k9s
- https://k9scli.io/
- https://github.com/derailed/k9s

> K9s is a terminal based UI to interact with your Kubernetes clusters. The aim of this project is to make it easier to navigate, observe and manage your deployed applications in the wild. K9s continually watches Kubernetes for changes and offers subsequent commands to interact with your observed resources.

### Basic usage
By default you can do most of the things you could with `kubectl` with `k9s` as well. That includes destructive actions like deleting resources, draining nodes, etc. To prevent accidents it is recommended to use it in read-only mode by default. You can either use a k9s configuration file or start it with the flag `--readonly`.

You can put an alias in your `~/.bashrc` if you want to be able to just type `k9s` to start it:

```
echo "alias k9s='k9s --readonly'" >> ~/.bashrc
```

## stern
- https://github.com/stern/stern
> Stern allows you to tail multiple pods on Kubernetes and multiple containers within the pod. Each result is color coded for quicker debugging.

Usually if you look at logs with k9s or kubectl you only look at the log output of one pod. With stern you can for example look at the log output from all our platform API pods simultaneously.

### Basic usage

```
stern pod-query [flags]
```

Platform API example (excluding mediawiki-api pods):
```
$ stern api -E mediawiki
api-app-backend-7c67f9d578-sqkcm api-backend 172.17.0.1 - - [25/Nov/2022:11:29:00 +0000] "GET /backend/healthz HTTP/1.1" 200 379 "-" "kube-probe/1.22"
api-app-backend-7c67f9d578-sqkcm api-backend 172.17.0.1 - - [25/Nov/2022:11:29:00 +0000] "GET /backend/healthz HTTP/1.1" 200 379 "-" "kube-probe/1.22"
api-app-web-578b87f46d-72hmd api-web 172.17.0.1 - - [25/Nov/2022:11:28:59 +0000] "GET /healthz HTTP/1.1" 200 379 "-" "kube-probe/1.22"
api-app-web-578b87f46d-72hmd api-web 172.17.0.1 - - [25/Nov/2022:11:28:59 +0000] "GET /healthz HTTP/1.1" 200 379 "-" "kube-probe/1.22"
api-app-backend-7c67f9d578-sqkcm api-backend 172.17.0.1 - - [25/Nov/2022:11:29:03 +0000] "GET /backend/qs/getBatches HTTP/1.1" 200 399 "-" "WBStack - Query Service - Updater"
api-scheduler-84d849f549-rmx4r api-queue [2022-11-25T11:29:03+00:00] Running scheduled command: App\Jobs\ProvisionWikiDbJob
api-scheduler-84d849f549-rmx4r api-queue [2022-11-25T11:29:04+00:00] Running scheduled command: App\Jobs\ProvisionQueryserviceNamespaceJob
api-queue-7f4dc6b6cc-fndgz api-queue [2022-11-25 11:29:07][WOibDiz4BFofxej7Un6qcRg7DV23EN7O] Processing: App\Jobs\ProvisionWikiDbJob
api-queue-7f4dc6b6cc-fndgz api-queue [2022-11-25 11:29:07][WOibDiz4BFofxej7Un6qcRg7DV23EN7O] Processed:  App\Jobs\ProvisionWikiDbJob
```

## kubeshark
- https://kubeshark.co/
- https://github.com/kubeshark/kubeshark

kubeshark is an API Traffic Viewer for kubernetes. Can be useful if you want inspect the communication between resources and the k8s API.

### Basic usage

```
$ kubeshark tap
```

A browser tab with the interface will open.

