# skaffold


** **This skaffold setup currently has the assumption that you have all wbaas / wbstack related repositories checked out in the same directory so that relative paths work..** **

```
wbstack/
|
├── api
├── charts
├── cradle
├── deploy
├── magnustools
├── mediawiki
├── queryservice-updater
├── quickstatements
├── ui
├── wbaas-deploy <--- this repository
└── widar

```
## Install dependencies

- [yq](https://github.com/mikefarah/yq)

## Install skaffold

https://skaffold.dev/docs/install/

This is very much a work in progress & might not work at all and certainly not be fully optimized etc...


## Use with minikube deployed helm charts

Inside the `skaffold/` directory run

```sh
skaffold run
```

This will build local images and apply them to the cluster. Every time you make a change that you wish to deploy to the cluster you will need to run this command.

Currently the following services are hooked up to skaffold:

- [ui](https://github.com/wbstack/ui/)
- [mediawiki-136](https://github.com/wbstack/mediawiki/)
- [api](https://github.com/wbstack/api)
- [queryservice-gateway](https://github.com/wbstack/queryservice-gateway)


## Reading

https://skaffold.dev/docs/pipeline-stages/deployers/helm/
