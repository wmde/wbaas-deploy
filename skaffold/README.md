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

## Use with minikube deployed helm charts

Inside the `skaffold/` directory run

```sh
skaffold run --kube-context minikube-wbaas 
```

This will build local images and apply them to the cluster. Every time you make a change that you wish to deploy to the cluster you will need to run this command.

Currently the following services are hooked up to skaffold:

- [ui](https://github.com/wbstack/ui/)
- [mediawiki-143](https://github.com/wbstack/mediawiki/)
- [api](https://github.com/wbstack/api)
- [queryservice-gateway](https://github.com/wbstack/queryservice-gateway)
- [queryservice-ui](https://github.com/wbstack/queryservice-ui)
- [queryservice](https://github.com/wbstack/queryservice)
- [queryservice-updater](https://github.com/wbstack/queryservice-updater)
- [tool-cradle](https://github.com/wbstack/cradle)
- [tool-widar](https://github.com/wbstack/widar)
- [tool-quickstatements](https://github.com/wbstack/quickstatements)

These are all configured as separate modules. To run a single module run
```sh
skaffold run --kube-context minikube-wbaas -m <module>
```

>[!TIP]
> You can run `make skaffold-run` or `make skaffold-<module>` from the root of this repo, without having to `cd` into this `skaffold` dir

## Reading

https://skaffold.dev/docs/pipeline-stages/deployers/helm/
https://skaffold.dev/docs/references/yaml
