# Argo CD
## How is Argo CD able to manage the cluster it lives in?
There is this RBAC role that gets added: https://github.com/argoproj/argo-cd/blob/ae29279cbe7d9df3b2162f39461a61f72aac0589/manifests/base/application-controller-roles/argocd-application-controller-role.yaml#L11

From the [k8s docs](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-and-clusterrole): 
```
- apiGroups: [""] # "" indicates the core API group
```

I think if we wanted to lock these permissions further down, we could for example only allow certain namespaces for deployment.
```
To fine-tune privileges which Argo CD has against its own cluster (i.e. https://kubernetes.default.svc), edit the following cluster roles where Argo CD is running in:

# run using a kubeconfig to the cluster Argo CD is running in
kubectl edit clusterrole argocd-server
kubectl edit clusterrole argocd-application-controller
```
https://argo-cd.readthedocs.io/en/stable/operator-manual/security/#cluster-rbac

