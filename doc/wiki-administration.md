# Wiki Administration
Currently the Platform UI only offers limited ways for a WikiManager to manage their wikibase.cloud Wikibases and manual intervention becomes necessary upon request. For certain scenarios we created code to perform these actions, in order to reduce mistakes and inconsistent database states for others we run commands using `tinker`.

If we are regularly performing the same types of interventions using tinker we should create a command.

## Soft-Deleting a Wiki
[Wiki/Delete Command](https://github.com/wbstack/api/blob/main/app/Console/Commands/Wiki/Delete.php)
```
$ kubectl exec -ti deployments/api-app-backend -- php artisan wbs-wiki:delete domain 'fjdsjkfdskjfdskjfds.wbaas.dev'
Success!
```

- This Commands first argument defines the key it should look for in the database via the second argument
  - Domain is recommended, as there is less potential for mistakes then with numeral IDs

### Restoring a Soft-Deleted Wiki
In case you need to restore a soft-deleted wiki, there currently is not a ready Command there yet for this, and it is recommended to create one if ever needed. However, in emergencies it can also be achieved via `artisan tinker`. A session could look like this:

```
$ kubectl exec -ti deployments/api-app-backend -- php artisan tinker
Psy Shell v0.12.0 (PHP 8.2.29 — cli) by Justin Hileman

# Verify wiki information
> Wiki::withTrashed()->firstWhere('domain', 'fjdsjkfdskjfdskjfds.wbaas.dev')
[!] Aliasing 'Wiki' to 'App\Wiki' for this Tinker session.
= App\Wiki {#7518
    id: 7,
    domain: "fjdsjkfdskjfdskjfds.wbaas.dev",
    sitename: "fdfs",
    deleted_at: "2025-11-06 17:27:49",
    created_at: "2025-11-06 17:26:52",
    updated_at: "2025-11-06 17:27:49",
    description: null,
    is_featured: 0,
    wiki_deletion_reason: null,
    +domain_decoded: "fjdsjkfdskjfdskjfds.wbaas.dev",
  }

# Restore the soft-deleted wiki
> Wiki::withTrashed()->firstWhere('domain', 'fjdsjkfdskjfdskjfds.wbaas.dev')->restore()
= true

# Verify again, notice that `deleted_at` is now null
> Wiki::firstWhere('domain', 'fjdsjkfdskjfdskjfds.wbaas.dev') 
= App\Wiki {#6537
    id: 7,
    domain: "fjdsjkfdskjfdskjfds.wbaas.dev",
    sitename: "fdfs",
    deleted_at: null,
    created_at: "2025-11-06 17:26:52",
    updated_at: "2025-11-06 17:29:24",
    description: null,
    is_featured: 0,
    wiki_deletion_reason: null,
    +domain_decoded: "fjdsjkfdskjfdskjfds.wbaas.dev",
  }
```

## Removing a Wikibase Logo and restoring the default
kubectl exec -it deployment/api-app-backend -- sh -c "php artisan tinker --execute=\"Wiki::where(['domain' => '<Wikibase Domain e.g. coffeebase.wikibase.dev>'])->first()->deleteSetting('wgLogo');\"" 
