# Argo CD
## Admin access
> Caution! Admin access should only happen in rare circumstances (testing/diagnosing, for example)
> as we want to maintain the configuration for everything in git.

username: `admin`
password: run `./bin/get-argocd-password`, which currently decodes `argocd-initial-admin-secret`

1. Enable admin access by flipping `admin.enabled` to `true` in our values file (or manually in the ConfigMap `argocd-cm`)
    - this is enabled for local clusters by default
2. Forward port `8080` of the pod `argocd-server`
    - use Makefile target `argocd-port-forward`
    - or `kubectl -n argocd port-forward deployments/argo-cd-base-argocd-server 8080`
3. Visit https://localhost:8080/ and log in.
    - for local clusters TLS is disabled: http://localhost:8080/
