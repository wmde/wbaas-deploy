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

### Security considerations
Currently this configuration leaves the initial admin account that gets created as-is, which means the password is unchanged and stored in plain-text as a k8s secret. This is considered bad practice. It still seems like an acceptable solution for now, as the we do not publicly expose ArgoCD and keep the admin account disabled (with the option to flick it on when needed). Alternatives would be to configure and use SSO or encrypted secrets, which would entail considerable amounts of effort vs little benefit. We can also change the password manually and keep it off-site.