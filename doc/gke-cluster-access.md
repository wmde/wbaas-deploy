# Setting up local access to GKE cluster

In order to manage Production and Staging GKE clusters from your dev machine you will need to:
- Authenticate with the `gcloud` CLI
- Create a `kubectl` context for each cluster

## Prerequisites

The following tools need to be installed on your system:
- [`kubectl`][install-kubectl] (this doc assumes **version >= 1.25**)
- [`gcloud`][install-gcloud]
- [`gke-gcloud-auth-plugin`][install-gke-auth-plugin] 

[install-kubectl]: https://kubernetes.io/docs/tasks/tools/
[install-gcloud]: https://cloud.google.com/sdk/docs/install
[install-gke-auth-plugin]: https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke

In your shell's environment, set

```
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
```

You can do this either ad-hoc for your current session, or in your shell's `.rc` file.

## Authenticating the `gcloud` CLI

To authenticate the `gcloud` CLI, you need to run

```
gcloud auth login
```

which opens a browser that lets you log in using your target Google Account.
Alternatively, pass `--no-browser` and follow the instructions in your terminal.

If you have never used `gcloud` on your current setup before, you will also need to set the current project:

```
gcloud config set project wikibase-cloud
```

## Creating `kubectl` contexts

After authenticating with `gcloud`, you can now create `kubectl` contexts for Staging:

```
gcloud container clusters get-credentials wbaas-2 --zone europe-west3-a
```

and Production

```
gcloud container clusters get-credentials wbaas-3 --zone europe-west3-a
```

## Using the contexts

To use these contexts, use `kubectl config set`.
E.g. in order to point your `kubectl` at staging, run:

```
kubectl config set-context gke_wikibase-cloud_europe-west3-a_wbaas-2
```

Note that the context names do not reuse names provided when calling `get-credentials`, but add a prefix.
`-2` will still be Staging, and `-3` Production.

## Optional: Adding the currently targeted context to your prompt

To save you from inadvertently targeting the wrong cluster, it is advised to add some mechanism to your shell that displays the current context in your shell's prompt.
In case you use `ohmyzsh` for example, you can use the [`kubectx` plugin][ohmyzsh-kubectx-plugin].

[ohmyzsh-kubectx-plugin]: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectx
