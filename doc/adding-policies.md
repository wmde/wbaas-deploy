# Adding policies

Example command for adding a new policy to the platform:

```sh
kubectl exec -it deployments/api-app-backend --context minikube-wbaas -- \
    php artisan tinker --execute "
        \App\Policy::create([
            'policy_type' => 'hosting-policy',
            'active_from' => '2026-07-01',
            'content_vue_file' => 'hosting-policy/version-1.vue'
        ]);
    "
```
