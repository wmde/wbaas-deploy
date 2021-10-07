# skaffold

Install skaffold

https://skaffold.dev/docs/install/

This is very much a work in progress & might not work at all and certainly not be fully optimized etc...

**Assumption**

This skaffold setup currently has the assumption that you have all wbaas / wbstack related repositories checked out in the same directory so that relative paths work..

## Use with minikube deployed helm charts

Currently the ui is the only service hooked up to skaffold.

Simply change some code in the `ui` repository and run:

```sh
skaffold run
```

Once complete you should see your changes reflected in the locally deployed environment.

## Reading

https://skaffold.dev/docs/pipeline-stages/deployers/helm/