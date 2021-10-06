## Dev

Install kind
https://kind.sigs.k8s.io/docs/user/quick-start/#installation

In the dev dir:

```sh
terraform init
terraform apply
```

You should have an empty k8s cluster running locally.

### Different k8s clusters

We can choose to use different k8s clusters, k3d & kind work through terraform, but terraform need not be used, and we could use minikube, or docker desktop or anything else.